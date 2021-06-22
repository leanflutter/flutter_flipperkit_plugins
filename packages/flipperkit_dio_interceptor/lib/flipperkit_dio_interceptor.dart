library flipperkit_dio_interceptor;

import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class FlipperKitDioInterceptor extends InterceptorsWrapper {
  final _uuid = Uuid();
  final _flipperNetworkPlugin = FlipperClient.getDefault()
      .getPlugin(FlipperNetworkPlugin.ID) as FlipperNetworkPlugin?;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    _reportRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    _reportResponse(response);
    handler.next(response);
  }

  @override
  void onError(
      DioError err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response != null) {
      _reportResponse(err.response!);
    }
    handler.next(err);
  }

  void _reportRequest(RequestOptions options) {
    var uniqueId = _uuid.v4();

    options.extra.putIfAbsent('__uniqueId__', () => uniqueId);

    var requestInfo = RequestInfo(
      requestId: uniqueId,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      uri: '${options.baseUrl}${options.path}',
      headers: options.headers,
      method: options.method,
      body: options.data,
    );

    _flipperNetworkPlugin?.reportRequest(requestInfo);
  }

  void _reportResponse(Response response) {
    var uniqueId = response.requestOptions.extra['__uniqueId__'];

    var responseInfo = ResponseInfo(
      requestId: uniqueId,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      statusCode: response.statusCode,
      headers: response.headers.map,
      body: response.data,
    );

    _flipperNetworkPlugin?.reportResponse(responseInfo);
  }
}

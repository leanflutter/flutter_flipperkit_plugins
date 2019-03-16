library flipperkit_dio_interceptor;

import 'dart:io';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class FlipperKitDioInterceptor extends InterceptorsWrapper {
  Uuid _uuid = new Uuid();
  FlipperNetworkPlugin _flipperNetworkPlugin;

  FlipperKitDioInterceptor() {
    _flipperNetworkPlugin =
        FlipperClient.getDefault().getPlugin(FlipperNetworkPlugin.ID);
  }

  @override
  onRequest(RequestOptions options) {
    this._reportRequest(options);
    return options;
  }

  @override
  onResponse(Response response) {
    this._reportResponse(response);
    return response;
  }

  @override
  onError(DioError err) {
    if (err.response != null) {
      this._reportResponse(err.response);
    }
    return err;
  }

  void _reportRequest(RequestOptions options) {
    String uniqueId = _uuid.v4();
    options.extra.putIfAbsent("__uniqueId__", () => uniqueId);
    RequestInfo requestInfo = new RequestInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      uri: '${options.baseUrl}${options.path}',
      headers: options.headers,
      method: options.method,
      body: options.data,
    );

    _flipperNetworkPlugin.reportRequest(requestInfo);
  }

  void _reportResponse(Response response) {
    Map<String, dynamic> headers = new Map();
    for (var key in []
      ..addAll(HttpHeaders.entityHeaders)
      ..addAll(HttpHeaders.requestHeaders)
      ..addAll(HttpHeaders.responseHeaders)) {
      var value = response.headers.value(key);

      if (value != null && value.isNotEmpty) {
        headers.putIfAbsent(key, () => value);
      }
    }
    String uniqueId = response.request.extra['__uniqueId__'];
    ResponseInfo responseInfo = new ResponseInfo(
      requestId: uniqueId,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      statusCode: response.statusCode,
      headers: headers,
      body: response.data,
    );

    _flipperNetworkPlugin.reportResponse(responseInfo);
  }
}

library flipperkit_redux_middleware;

import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class FlipperKitReduxMiddleware<State> implements MiddlewareClass<State> {
  Uuid _uuid = new Uuid();

  FlipperReduxInspectorPlugin _flipperReduxInspectorPlugin;

  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    next(action);

    if (_flipperReduxInspectorPlugin == null) {
      _flipperReduxInspectorPlugin =
          FlipperClient.getDefault().getPlugin("ReduxInspector");
    }

    String uniqueId = _uuid.v4();
    ActionInfo actionInfo = new ActionInfo(
      uniqueId: uniqueId,
      actionType: action.runtimeType.toString(),
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      state: json.encode(store.state),
    );

    _flipperReduxInspectorPlugin.report(actionInfo);
  }
}

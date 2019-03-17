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
    dynamic prevState = json.encode(store.state);
    next(action);
    dynamic nextState = json.encode(store.state);

    if (_flipperReduxInspectorPlugin == null) {
      _flipperReduxInspectorPlugin =
          FlipperClient.getDefault().getPlugin("ReduxInspector");
    }

    String uniqueId = _uuid.v4();

    var payload;
    try {
       payload = json.encode(action);
    } catch (e) {}
    
    ActionInfo actionInfo = new ActionInfo(
      uniqueId: uniqueId,
      actionType: action.runtimeType.toString(),
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      payload: payload,
      prevState: prevState,
      nextState: nextState,
    );

    _flipperReduxInspectorPlugin.report(actionInfo);
  }
}

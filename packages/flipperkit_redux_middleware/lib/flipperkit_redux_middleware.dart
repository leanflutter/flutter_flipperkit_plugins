library flipperkit_redux_middleware;

import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class FlipperKitReduxMiddleware<State> implements MiddlewareClass<State> {
  Uuid _uuid = new Uuid();
  FlipperReduxInspectorPlugin _flipperReduxInspectorPlugin;

  bool Function(String actionType) filter;

  FlipperKitReduxMiddleware({
    this.filter,
  });

  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    String actionType = action.runtimeType.toString();
    dynamic prevState = json.encode(store.state);
    next(action);
    
    if (filter != null && filter(actionType)) {
      return;
    }

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
      actionType: actionType,
      timeStamp: new DateTime.now().millisecondsSinceEpoch,
      payload: payload,
      prevState: prevState,
      nextState: nextState,
    );

    _flipperReduxInspectorPlugin.report(actionInfo);
  }
}

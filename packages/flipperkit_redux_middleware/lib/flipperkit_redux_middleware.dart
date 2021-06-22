library flipperkit_redux_middleware;

import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:uuid/uuid.dart';

class FlipperKitReduxMiddleware<State> implements MiddlewareClass<State> {
  final _uuid = Uuid();
  FlipperReduxInspectorPlugin? _flipperReduxInspectorPlugin;

  bool Function(String actionType)? filter;
  String Function(dynamic action) getActionType;
  dynamic Function(State state) stateConverter;
  dynamic Function(dynamic payload) payloadConverter;

  FlipperKitReduxMiddleware({
    this.filter,
    this.getActionType = _defaultActionTypeConverter,
    this.stateConverter = jsonEncode,
    this.payloadConverter = jsonEncode,
  });

  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    var prevState = stateConverter(store.state);
    next(action);

    var actionType = getActionType(action);

    // Action is filtered, Do not report
    if (filter?.call(actionType) == true) {
      return;
    }

    var nextState = stateConverter(store.state);

    tryInitializingPlugin();

    var payload = payloadConverter(action);

    var actionInfo = ActionInfo(
      uniqueId: _uuid.v4(),
      actionType: actionType,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      payload: payload,
      prevState: prevState,
      nextState: nextState,
    );

    _flipperReduxInspectorPlugin?.report(actionInfo);
  }

  void tryInitializingPlugin() {
    _flipperReduxInspectorPlugin ??=
        FlipperClient.getDefault().getPlugin('flipper-plugin-reduxinspector')
            as FlipperReduxInspectorPlugin?;
  }

  static String _defaultActionTypeConverter(action) => action.toString();
}

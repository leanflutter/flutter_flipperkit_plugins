library flipperkit_fish_redux_middleware;

import 'dart:convert';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:uuid/uuid.dart';

Middleware<T> flipperKitFishReduxMiddleware<T>() {
  Uuid _uuid = Uuid();

  return ({Dispatch dispatch, Get<T> getState}) {
    return (Dispatch next) {
      if (!isDebug()) return next;

      return (Action action) {
        String actionType = '${action.type}';
        final prevState = json.encode(getState());
        next(action);
        
        if (actionType.startsWith('\$')) {
          return;
        }

        final nextState = json.encode(getState());

        String uniqueId = _uuid.v4();
        ActionInfo actionInfo = new ActionInfo(
          uniqueId: uniqueId,
          actionType: actionType,
          timeStamp: new DateTime.now().millisecondsSinceEpoch,
          payload: json.encode(action.payload) ?? <String, String>{},
          prevState: prevState,
          nextState: nextState,
        );

        FlipperReduxInspectorPlugin _flipperReduxInspectorPlugin =
          FlipperClient.getDefault().getPlugin("ReduxInspector");

        if (_flipperReduxInspectorPlugin != null) {
          _flipperReduxInspectorPlugin.report(actionInfo);
        }
      };
    };
  };
}

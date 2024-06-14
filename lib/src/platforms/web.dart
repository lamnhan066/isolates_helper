import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolates_helper/src/function.dart';

/// Web platform does not need to use the `function`
Future<R> platformExecute<R extends Object, P extends Object>({
  required IsolateManager<Object, Object> manager,
  required FutureOr<R> Function(P) function,
  required P params,
  required String? workerFunction,
  required Object? workerParams,
  required bool isWorker,
  required bool isDebug,
}) async {
  if (isDebug && isWorker && workerFunction == null) {
    print('[Isolates Helper] Worker is available but `workerFunction` is null, '
        'so `Future` will be used instead');
  }

  if (isWorker && workerFunction != null) {
    final finalParams = workerParams ?? params;
    return (await manager.compute([workerFunction, finalParams])) as R;
  } else {
    final completer = Completer<R>();
    completer.complete(function(params));
    return completer.future;
  }
}

/// Create a Worker on Web.
void workerFunctionImpl(Map<String, Function> map) {
  IsolateManagerFunction.workerFunction((List<Object> message) {
    return internalFunction([map[message[0]] as Function, message[1]]);
  });
}

import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';

/// Execute
Future<R> platformExecute<R extends Object, P extends Object>({
  required IsolateManager<Object, Object> manager,
  required FutureOr<R> Function(P) function,
  required P params,
  required String? workerFunction,
  required Object? workerParams,
  required bool isWorker,
  required bool isDebug,
}) async {
  return (await manager.compute([function, params])) as R;
}

/// Create a Worker on Web.
void workerFunctionImpl(Map<String, Function> map) {
  throw UnimplementedError('Only implemented on the Web for the Worker');
}

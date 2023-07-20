import 'package:isolate_manager/isolate_manager.dart';

/// Execute
Future<R> platformExecute<R extends Object, P extends Object>({
  required IsolateManager<Object, Object> manager,
  required Object function,
  required P params,
  required String? workerFunction,
  required Object? workerParams,
  required bool isWorker,
  required bool isDebug,
}) async {
  return (await manager.compute([function, params])) as R;
}

import 'package:isolate_manager/isolate_manager.dart';

/// Web platform does not need to use the `function`
Future<R> platformExecute<R extends Object, P extends Object>({
  required IsolateManager<Object, Object> manager,
  required Object function,
  required P params,
  required String? workerFunction,
  required Object? workerParams,
  required bool isWorker,
}) async {
  if (isWorker) {
    assert(
      workerFunction != null,
      'Function name must not be null when using Worker',
    );

    // Worker doesn't allow passing function
    return (await manager.compute([workerFunction!, workerParams ?? params]))
        as R;
  } else {
    return (await manager.compute([function, params])) as R;
  }
}

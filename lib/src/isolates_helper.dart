import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolates_helper/src/function.dart';

import 'platforms/stub.dart' if (dart.library.html) 'platforms/web.dart';

class IsolatesHelper {
  /// Create a worker in your `main`.
  ///
  /// ```dart
  /// main() {
  ///   /* Mapping between your function as String and real `Function`.
  ///   This function MUST NOT depends on any Flutter library. */
  ///   IsolatesHelper.workerFunction({
  ///     'add' : add,
  ///   });
  /// }
  /// ```
  ///
  /// Build it with `dart compile js worker.dart -o worker.js -O4` and copy the `worker.js` to
  /// your Web folder.
  ///
  /// If you need to throw an exception, you should only throw the `message`
  /// instead of a whole Object because it may not be shown as expected when
  /// sending back to the main app.
  ///
  /// ``` dart
  ///  return throw 'This is an error that you need to catch in your main app';
  /// ```
  static void workerFunction(Map<String, Function> map) =>
      workerFunctionImpl(map);

  /// The instance of the [IsolateManager].
  late final IsolateManager<Object, List<Object>> _manager;

  /// Check that the [IsolateManager] is started or not.
  bool get isStarted => _ensureCompleter.isCompleted;

  /// Ensure that the [IsolatesHelper] was already started.
  Future<void> get ensureStarted => _ensureCompleter.future;
  final Completer<void> _ensureCompleter = Completer();

  /// Create multiple long live isolates for computation.
  ///
  /// [concurrent] is a number of isolates that you want to create.
  ///
  /// [worker] is the worker name for the isolates. Ex: worker.js => worker: 'worker'.
  ///
  /// [workerConverter] is a converter for the worker, the data from the worker
  /// will be directly sent to this method to convert to the result format that
  /// you want to.
  ///
  /// [isDebug] print the debug log.
  IsolatesHelper({
    int concurrent = 1,
    String worker = '',
    Object Function(dynamic)? workerConverter,
    bool isDebug = false,
  }) {
    IsolateManager.debugLogPrefix = 'Isolates Helper';
    _manager = IsolateManager.create(
      internalFunction,
      workerName: worker,
      workerConverter: workerConverter,
      concurrent: concurrent,
      isDebug: isDebug,
    )..start().then((value) {
        _ensureCompleter.complete();
      });
  }

  /// Compute the given [function] with given [params].
  ///
  /// [workerFunction] is the name of the function that have created in `worker.dart`.
  ///
  /// [workerParams] is specific params for `Worker`, [params] will be use if this value is null.
  ///
  /// Equavient of [compute].
  Future<R> call<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params, {
    String? workerFunction,
    Object? workerParams,
  }) {
    return _excute(
      function,
      params,
      workerFunction: workerFunction,
      workerParams: workerParams,
    );
  }

  /// Compute the given [function] with given [params].
  ///
  /// [workerFunction] is the name of the function that have created in `worker.dart`.
  ///
  /// [workerParams] is specific params for `Worker`, [params] will be use if this value is null.
  Future<R> compute<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params, {
    String? workerFunction,
    Object? workerParams,
  }) {
    return _excute(
      function,
      params,
      workerFunction: workerFunction,
      workerParams: workerParams,
    );
  }

  /// Execute the given [function] with its' [params].
  Future<R> _excute<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params, {
    String? workerFunction,
    Object? workerParams,
  }) async {
    return platformExecute<R, P>(
      manager: _manager,
      function: function,
      params: params,
      workerFunction: workerFunction,
      workerParams: workerParams,
      isWorker: _manager.workerName != '',
      isDebug: _manager.isDebug,
    );
  }

  /// Get the result as stream.
  Stream<Object> get stream => _manager.stream;

  /// Restart all the isolates.
  Future<void> restart() => _manager.restart();

  /// Stop all the isolates.
  Future<void> stop() => _manager.stop();
}

import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolates_helper/src/function.dart';

/// [R] is the return type of the function
class IsolatesHelper {
  /// The instance of the [IsolateManager]
  late final IsolateManager<Object, List<Object>> _manager;

  /// Check that the [IsolateManager] is started or not
  bool get isStarted => _ensureCompleter.isCompleted;

  /// Ensure that the [IsolatesHelper] was already started.
  Future<void> get ensureStarted => _ensureCompleter.future;
  final Completer<void> _ensureCompleter = Completer();

  /// Create multiple long live isolates for computation.
  ///
  /// [concurrent] is a number of isolates that you want to create.
  ///
  /// [worker] is the worker name for the isolates. Ex: worker.js => worker: 'worker'
  ///
  /// [workerConverter] is a converter for the worker, the data from the worker
  /// will be directly sent to this method to convert to the result format that
  /// you want to.
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

  /// Compute the given [function] with its' [params].
  ///
  /// Equavient of [compute]
  Future<R> call<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params,
  ) {
    return _excute(function, params);
  }

  /// Compute the given [function] with its' [params].
  Future<R> compute<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params,
  ) {
    return _excute(function, params);
  }

  /// Execute the given [function] with its' [params].
  Future<R> _excute<R extends Object, P extends Object>(
    FutureOr<R> Function(P) function,
    P params,
  ) async {
    final result = await _manager.compute([function, params]);
    return result as R;
  }

  /// Get the result as stream
  Stream<Object> get stream => _manager.stream;

  /// Restart all the isolates
  Future<void> restart() => _manager.restart();

  /// Stop all the isolates
  Future<void> stop() => _manager.stop();
}

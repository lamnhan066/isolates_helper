import 'dart:async';

/// Internal function
@pragma('vm:entry-point')
Future<R> internalFunction<R>(dynamic params) async {
  assert(params is List, 'params is not a list');
  assert((params as List).length == 2, 'params must have only 2 elements');
  assert(params[0] is FutureOr<R> Function(dynamic),
      'params[0] is not a FutureOr<$R> Function(dynamic)');

  Completer<R> completer = Completer();
  completer.complete(params[0](params[1]));
  return completer.future;
}

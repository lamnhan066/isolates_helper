import 'dart:async';

/// Internal function
@pragma('vm:entry-point')
Future<Object> internalFunction(List<Object> params) async {
  // assert(params is List, 'params is not a list');
  assert(params.length == 2, 'params must have only 2 elements');
  assert(params[0] is Function, 'params[0] is not a Function');

  Completer<Object> completer = Completer();
  completer.complete((params[0] as Function)(params[1]));
  return completer.future;
}

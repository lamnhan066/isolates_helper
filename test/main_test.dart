import 'dart:async';

import 'package:isolates_helper/src/isolates_helper.dart';
import 'package:test/test.dart';

//  dart test
//  dart test --platform=chrome,vm

void main() async {
  test('test', () {
    // Create 3 isolates to solve the problems
    final isolates = IsolatesHelper(concurrent: 3);

    isolates.stream.listen((result) {
      if (result is double) {
        print('Stream get addFuture: $result');
      } else if (result is String) {
        print('Stream get concat: $result');
      } else {
        print('Stream get add: $result');
      }
    });

    for (double i = 0; i < 10; i++) {
      isolates.compute(addFuture, [i, i]).then((value) async {
        print('addFuture: $i + $i = $value');
        expect(value, equals(await addFuture([i, i])));
      });
    }

    for (int i = 0; i < 10; i++) {
      isolates(add, [i, i]).then((value) {
        print('add: $i + $i = $value');
        expect(value, equals(add([i, i])));
      });
    }

    for (int i = 0; i < 10; i++) {
      isolates.compute(concat, ['$i', '$i']).then((value) {
        print('add: $i + $i = $value');
        expect(value, equals(concat(['$i', '$i'])));
      });
    }

    // Stop the usolate after 5 seconds
    Timer(Duration(seconds: 5), () {
      isolates.stop();
    });
  });

  test('test try-catch', () async {
    // Create 3 isolates to solve the problems
    final isolates = IsolatesHelper(concurrent: 3);

    // Catch the error from the stream
    isolates.stream.listen((result) {
      print('Stream get add: $result');
    }).onError((e) {
      print('Error from stream: $e');
      expect(e, isA<ArgumentError>());
    });

    // Catch the error from the try-catch block
    try {
      await isolates.compute(addException, [1, 1]);
    } catch (e) {
      print('Error from try-catch: $e');
      expect(e, isA<ArgumentError>());
    }

    // Stop the usolate after 5 seconds
    Timer(Duration(seconds: 5), () {
      isolates.stop();
    });
  });

  test('Ensure started', () async {
    // The first `compute` will ensure started automatically
    final isolates1 = IsolatesHelper(concurrent: 1);

    final stopWatch = Stopwatch()..start();
    expect(isolates1.isStarted, equals(false));
    await isolates1.compute(addFuture, [2.0, 3.0]);
    final stopWithoutEnsured = stopWatch.elapsedMicroseconds;

    // reset stopwatch
    stopWatch
      ..stop()
      ..reset();

    // Calling the `compute` method after waiting for `ensureStarted`.
    final isolates2 = IsolatesHelper(concurrent: 1);
    await isolates2.ensureStarted;
    expect(isolates1.isStarted, equals(true));

    stopWatch.start();
    await isolates2.compute(addFuture, [2.0, 3.0]);
    final stopWithEnsured = stopWatch.elapsedMicroseconds;
    stopWatch.stop();

    await isolates1.stop();
    await isolates2.stop();

    print(stopWithoutEnsured);
    print(stopWithEnsured);

    // The stopWithoutEnsured will always greater than the stopWithEnsured
    // because it needs to wait for the `ensureStarted` before computation.
    expect(stopWithoutEnsured, greaterThan(stopWithEnsured));
  });
}

Future<double> addFuture(List<double> values) async {
  return values[0] + values[1];
}

int add(List<int> values) {
  return values[0] + values[1];
}

int addException(dynamic values) {
  return throw ArgumentError();
}

String concat(List<String> params) {
  return '${params[0]} ${params[1]}';
}

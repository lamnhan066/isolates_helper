import 'dart:async';

import 'package:isolates_helper/src/isolates_helper.dart';
import 'package:test/test.dart';

import 'functions.dart';

//  dart test
//  dart test --platform=chrome,vm

void main() async {
  test('test', () {
    // Create 3 isolates to solve the problems
    final isolates = IsolatesHelper(concurrent: 3, worker: 'worker');

    isolates.stream.listen((result) {
      if (result is double) {
        // print('Stream get addFuture: $result');
      } else if (result is String) {
        // print('Stream get concat: $result');
      } else {
        // print('Stream get add: $result');
      }
    });

    for (double i = 0; i < 10; i++) {
      isolates
          .compute(addFuture, [i, i], workerFunction: 'addFuture')
          .then((value) async {
        expect(value, equals(await addFuture([i, i])));
      });
    }

    for (int i = 0; i < 10; i++) {
      isolates(add, [i, i], workerFunction: 'add').then((value) {
        expect(value, equals(add([i, i])));
      });
    }

    for (int i = 0; i < 10; i++) {
      isolates
          .compute(concat, ['$i', '$i'], workerFunction: 'concat')
          .then((value) {
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
    final isolates = IsolatesHelper(concurrent: 3, worker: 'worker');

    // Catch the error from the stream
    isolates.stream.listen((result) {
      // print('Stream get add: $result');
    }).onError((e) {
      // print('Error from stream: $e');
      expect(e.toString(), equals(ArgumentError().toString()));
    });

    // Catch the error from the try-catch block
    try {
      await isolates.compute(
        addException,
        [1, 1],
        workerFunction: 'addException',
      );
    } catch (e) {
      expect(e.toString(), equals(ArgumentError().toString()));
    }

    // Stop the usolate after 5 seconds
    Timer(Duration(seconds: 5), () {
      isolates.stop();
    });
  });

  // This test will work better if the `autoInitialized` is set to `false`.
  test('Ensure started', () async {
    // The first `compute` will ensure started automatically
    final isolates1 = IsolatesHelper(concurrent: 1, worker: 'worker');

    final stopWatch = Stopwatch()..start();
    expect(isolates1.isStarted, equals(false));
    await isolates1.compute(addFuture, [2.0, 3.0], workerFunction: 'addFuture');
    final stopWithoutEnsured = stopWatch.elapsedMicroseconds;

    // reset stopwatch
    stopWatch
      ..stop()
      ..reset();

    // Calling the `compute` method after waiting for `ensureStarted`.
    final isolates2 = IsolatesHelper(concurrent: 1, worker: 'worker');
    await isolates2.ensureStarted;
    expect(isolates1.isStarted, equals(true));

    stopWatch.start();
    await isolates2.compute(addFuture, [2.0, 3.0], workerFunction: 'addFuture');
    final stopWithEnsured = stopWatch.elapsedMicroseconds;
    stopWatch.stop();

    await isolates1.stop();
    await isolates2.stop();

    // The stopWithoutEnsured will always greater than the stopWithEnsured
    // because it needs to wait for the `ensureStarted` before computation.
    expect(stopWithoutEnsured, greaterThan(stopWithEnsured));
  });

  test('Complex return', () async {
    final isolates = IsolatesHelper();

    final result = await isolates.compute(
      complexReturn,
      <List<String>>[
        <String>['abc']
      ],
      workerFunction: 'complexReturn',
    );

    await isolates.restart();

    expect(result, isA<List<List<String>>>());
    expect(
        result,
        equals(<List<String>>[
          <String>['abc']
        ]));

    isolates.stop();
  });

  test('Test `workerFunction`', () {
    try {
      IsolatesHelper.workerFunction({});
    } catch (e) {
      expect(e, isA<UnimplementedError>());
    }
  });

  test('Test ignoring `workerFunction`', () async {
    final isolates = IsolatesHelper(concurrent: 3, worker: 'worker');

    final result = await isolates.compute(add, [2, 3]);
    expect(result, equals(5));
  });
}

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
      } else {
        print('Stream get add: $result');
      }
    });

    for (double i = 0; i < 10; i++) {
      isolates(addFuture, [i, i]).then((value) async {
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
}

Future<double> addFuture(dynamic values) async {
  return values[0] + values[1];
}

int add(dynamic values) {
  return values[0] + values[1];
}

int addException(dynamic values) {
  return throw ArgumentError();
}

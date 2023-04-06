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
}

Future<double> addFuture(dynamic values) async {
  return values[0] + values[1];
}

int add(dynamic values) {
  return values[0] + values[1];
}

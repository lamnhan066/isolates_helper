import 'package:isolates_helper/src/isolates_helper.dart';
import 'package:test/test.dart';

//  dart test
//  dart test --platform=chrome,vm

void main() async {
  test('test normal function', () {
    final isolates = IsolatesHelper(concurrent: 3);
    for (double i = 0; i < 10; i++) {
      isolates(add, [i, i]).then((value) => expect(value, add([i, i])));
    }
  });

  test('test future function', () {
    final isolates = IsolatesHelper(concurrent: 3);
    for (double i = 0; i < 10; i++) {
      isolates(addFuture, [i, i]).then(
        (value) async => expect(
          value,
          await addFuture([i, i]),
        ),
      );
    }
  });
}

double add(dynamic values) {
  return values[0] + values[1];
}

Future<double> addFuture(dynamic values) async {
  return values[0] + values[1];
}

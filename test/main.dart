import 'dart:async';

import 'package:isolates_helper/isolates_helper.dart';

void main() async {
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
    isolates(addFuture, [i, i]).then((value) {
      print('addFuture: $i + $i = $value');
    });
  }

  for (int i = 0; i < 10; i++) {
    isolates(add, [i, i]).then((value) async {
      print('add: $i + $i = $value');
    });
  }

  // Stop the usolate after 5 seconds
  Timer(Duration(seconds: 5), () {
    isolates.stop();
  });
}

Future<double> addFuture(dynamic values) async {
  return values[0] + values[1];
}

int add(dynamic values) {
  return values[0] + values[1];
}

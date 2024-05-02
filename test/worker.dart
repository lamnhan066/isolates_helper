import 'package:isolates_helper/isolates_helper.dart';

import 'functions.dart';

// dart compile js test/worker.dart -o test/worker.js -O4

void main() {
  IsolatesHelper.workerFunction({
    'addFuture': addFuture,
    'add': add,
    'addException': addException,
    'complexReturn': complexReturn,
    'concat': concat,
  });
}

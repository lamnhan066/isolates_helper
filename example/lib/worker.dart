import 'package:isolates_helper/isolates_helper.dart';
import 'package:isolates_helper_example/functions.dart';

/// ============================================
/// dart compile js worker.dart -o worker.js -O4
/// ============================================

/// In most cases you don't need to modify this function
main() {
  IsolatesHelper.workerFunction({
    'add': add,
    'subtract': subtract,
    'fibonacci': fibonacciRecursive,
  });
}

import 'package:isolates_helper/isolates_helper.dart';

@isolatesHelperWorker
int fibonacciRecursive(int n) {
  if (n == 0) return 0;
  if (n <= 2) return 1;

  return fibonacciRecursive(n - 1) + fibonacciRecursive(n - 2);
}

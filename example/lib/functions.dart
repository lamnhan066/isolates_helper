double add(List<double> values) => values[0] + values[1];

double subtract(List<double> values) => values[0] - values[1];

int fibonacciRecursive(int n) {
  if (n == 0) return 0;
  if (n <= 2) return 1;

  return fibonacciRecursive(n - 1) + fibonacciRecursive(n - 2);
}

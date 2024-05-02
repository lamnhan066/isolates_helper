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

List<List<String>> complexReturn(List<List<String>> params) {
  return params;
}

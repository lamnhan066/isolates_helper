import 'package:isolates_helper/isolates_helper.dart';

@isolatesHelperWorker
Future<double> addFuture(List<double> values) async {
  return values[0] + values[1];
}

@isolatesHelperWorker
int add(List<int> values) {
  return values[0] + values[1];
}

@isolatesHelperWorker
int addException(dynamic values) {
  return throw ArgumentError();
}

@isolatesHelperWorker
String concat(List<String> params) {
  return '${params[0]} ${params[1]}';
}

@isolatesHelperWorker
List<List<String>> complexReturn(List<List<String>> params) {
  return params;
}

import 'package:isolates_helper/isolates_helper.dart';

@isolatesHelperWorker
double add(List<double> values) => values[0] + values[1];

@isolatesHelperWorker
double subtract(List<double> values) => values[0] - values[1];

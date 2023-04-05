import 'package:flutter/material.dart';
import 'package:isolates_helper/isolates_helper.dart';

@pragma('vm:entry-point')
int add(dynamic values) => values[0] + values[1];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = '';
  final isolates = IsolatesHelper(concurrent: 3, isDebug: true);

  @override
  void initState() {
    super.initState();
  }

  void calculate() {
    isolates(add, [3, 4]).then((value) {
      setState(() => text = '$value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('Result: $text'),
            ElevatedButton(onPressed: calculate, child: const Text('Calculate'))
          ],
        )),
      ),
    );
  }
}

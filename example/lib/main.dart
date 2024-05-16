import 'package:flutter/material.dart';
import 'package:isolates_helper/isolates_helper.dart';

import 'functions.dart';
import 'functions1.dart';

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

  double value1 = 0;
  double value2 = 0;

  final isolates = IsolatesHelper(
    concurrent: 3,
    isDebug: true,
  );

  @override
  void initState() {
    super.initState();
  }

  void calculateAdd() {
    final List<double> params = [value1, value2];
    isolates(add, params, workerFunction: 'add').then((value) {
      setState(() => text = '$value');
    });
  }

  void calculateSubtract() {
    final List<double> params = [value1, value2];
    isolates(subtract, params, workerFunction: 'subtract').then((value) {
      setState(() => text = '$value');
    });
  }

  void calculateFibonacci() {
    final int params = value1.round();
    isolates(fibonacciRecursive, params, workerFunction: 'fibonacciRecursive')
        .then((value) {
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
            TextFormField(
              initialValue: '$value1',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                value1 = double.parse(value);
              },
            ),
            TextFormField(
              initialValue: '$value2',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                value2 = double.parse(value);
              },
            ),
            ElevatedButton(onPressed: calculateAdd, child: const Text('Add')),
            ElevatedButton(
                onPressed: calculateSubtract, child: const Text('Subtract')),
            ElevatedButton(
                onPressed: calculateFibonacci,
                child: const Text('Fibonacci for the first inputted value')),
          ],
        )),
      ),
    );
  }
}

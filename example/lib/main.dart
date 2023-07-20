import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isolates_helper/isolates_helper.dart';

import 'functions.dart';

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

  final isolates = IsolatesHelper(
    concurrent: 3,
    worker: 'worker',
    isDebug: true,
  );

  @override
  void initState() {
    super.initState();
  }

  void calculate() {
    final rand = Random();
    final params = [rand.nextInt(1000), rand.nextInt(1000)];
    isolates(add, params, workerFunction: 'add').then((value) {
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

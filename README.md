# Isolates Helper

* An easy way to create multiple long live isolates for computation.

* This package is based on the power of [isolate_manager](https://pub.dev/packages/isolate_manager) (also written by me) but can be used with mutiple functions.

* Support `try-catch` block.

## Usage

Define the number of isolates you want to live with `concurrent` parameter.

``` dart
void main() async {
  // Create 3 isolates to solve the problems
  final isolates = IsolatesHelper(concurrent: 3);

  // Listen for the results from the stream.
  isolates.stream.listen((result) {
    if (result is double) {
      print('Stream get addFuture: $result');
    } else {
      print('Stream get add: $result');
    }
  });

  // Compute the values. The return type and parameter type will respect the type
  // of the function.
  final added = await isolates.compute(addFuture, [1.1, 2.2]);
  print('add: 1.1 + 2.2 = $added');

  // Multiple computations at the same time are allowed. It will be queued
  // automatically.
  for (int i = 0; i < 10; i++) {
    isolates(add, [i, i]).then((value) async {
      print('add: $i + $i = $value');
    });
  }

  // Stop the IsolateHelper instance after 5 seconds
  Timer(Duration(seconds: 5), () {
    isolates.stop();
  });
}

@pragma('vm:entry-point')
Future<double> addFuture(List<double> values) async {
  return values[0] + values[1];
}

@pragma('vm:entry-point')
int add(List<int> values) {
  return values[0] + values[1];
}
```

Use `@pragma('vm:entry-point')` notation to avoid the function being trimmed when building in release mode.

Here is the ways to use `try-catch` block:

``` dart
// Catch the error from the stream
isolates.stream.listen((result) {
  print('Stream get add: $result');
}).onError((e) {
  print('Error from stream: $e');
});

// Catch the error from the try-catch block
try {
  await isolates.compute(addException, [1, 1]);
} catch (e) {
  print('Error from try-catch: $e');
}
```

The first `compute` will automatically wait for all isolates to started before doing the computation, if you want to wait for it manually, you can use:

``` dart
await isolates.ensureStarted;
```

Or you can check if the current isolates are started or still in processing by using:

``` dart
bool isStarted = isolates.isStarted;
```

You can restart all the isolates with:

``` Dart
await isolates.restart();
```

Remember to stop the isolates when you don't need it:

``` Dart
await isolates.stop();
```

## Worker

You need to do a little bit more works then using normal Isolate but don't worry, the below steps will help you to do it easily.

* **Step 1** Download [isolates_helper/worker/worker.dart](https://raw.githubusercontent.com/vursin/isolates_helper/main/worker/worker.dart) or copy the below code to the file named `worker.dart`:

  <details>
  
  <summary>worker.dart</summary>

  ``` dart
  // ignore_for_file: avoid_web_libraries_in_flutter, depend_on_referenced_packages

  import 'dart:async';
  import 'dart:html' as html;
  import 'dart:js' as js;

  import 'package:isolate_manager/isolate_manager.dart';
  import 'package:js/js.dart' as pjs;
  import 'package:js/js_util.dart' as js_util;

  @pjs.JS('self')
  external dynamic get globalScopeSelf;

  /// ============================================
  /// dart compile js worker.dart -o worker.js -O4
  /// ============================================

  /// TODO: Mapping between your `workerFunction` and real `Function`
  Map<String, Function> map = {
    // 'add': add,
  };

  /// In most cases you don't need to modify this function
  main() {
    callbackToStream('onmessage', (html.MessageEvent e) {
      return js_util.getProperty(e, 'data');
    }).listen((message) async {
      final Completer completer = Completer();
      completer.future.then(
        (value) => jsSendMessage(value),
        onError: (err, stack) =>
            jsSendMessage(IsolateException(err, stack).toJson()),
      );
      try {
        final function = map[message[0]] as Function;
        final params = message[1];
        completer.complete(function(params));
      } catch (err, stack) {
        jsSendMessage(IsolateException(err, stack).toJson());
      }
    });
  }

  /// Internal function
  Stream<T> callbackToStream<J, T>(
      String name, T Function(J jsValue) unwrapValue) {
    var controller = StreamController<T>.broadcast(sync: true);
    js_util.setProperty(js.context['self'], name, js.allowInterop((J event) {
      controller.add(unwrapValue(event));
    }));
    return controller.stream;
  }

  /// Internal function
  void jsSendMessage(dynamic m) {
    js.context.callMethod('postMessage', [m]);
  }

  ```

  </details>

* **Step 2** Modify the mapping between your `functionName` and real `function`:

  ```dart 
  /// TODO: Mapping between your `workerFunction` and real `Function`
  Map<String, Function> map = {
    // 'add': add,
  };
  ```

 **You should copy that functions to separated file or copy to `worker.dart` file to prevent the `dart compile js` error because some other functions depend on flutter library.**

* **Step 3:** Run `dart compile js worker.dart -o worker.js -O4` to compile dart to js (`-O0` to `-O4` is the obfuscated level of `js`).
* **Step 4:** Copy `worker.js` to web folder (the same folder with `index.html`).
* **Step 5:** Now you can add `worker` to `worker` parameter like below:

  ``` dart
  final isolates = IsolatesHelper(
    concurrent: 3,
    worker: 'worker',
    isDebug: true,
  );
  ```

* **Step 6** Here is the way to execute a Worker function

  ``` dart
  final result = await isolates(
    // Here is the normal function
    add, 

    // Here is the normal params
    [2, 3], 

    // Here is the name of the function that is mapped in the step 2
    workerFunction: 'add',
    
    // [Optional] the normal params will be used if this value is null
    workerParams: [2, 3], 
    );
  ```

## Contributions

If you encounter any problems or feel the library is missing a feature, feel free to open an issue. Pull requests are also welcome.

## Donations

If you like my work or the free stuff on this channel and want to say thanks, or encourage me to do more, you can buy me a coffee. Thank you so much!

<p align='center'><a href="https://paypal.me/lamnhan066">PayPal</a></p>
<p align='center'><a href="https://www.buymeacoffee.com/vursin"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=vursin&button_colour=5F7FFF&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00" width="200"></a></p>

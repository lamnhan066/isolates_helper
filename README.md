# Isolates Helper

* An easy way to create multiple long live isolates for computation.

* This package is based on the power of [isolate_manager](https://pub.dev/packages/isolate_manager) (which is also written by me) but can be used with mutiple functions.

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

  // Compute the values
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
Future<double> addFuture(dynamic values) async {
  return values[0] + values[1];
}

@pragma('vm:entry-point')
int add(dynamic values) {
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

## Additional

* This package also provides the way to implement Worker for Web platform. To keeps this package simple to use, you can read [here](https://pub.dev/packages/isolate_manager#worker-configuration) for more details when you need it.

## Contributions

If you encounter any problems or feel the library is missing a feature, feel free to open an issue. Pull requests are also welcome.

## Donations

If you like my work or the free stuff on this channel and want to say thanks, or encourage me to do more, you can buy me a coffee. Thank you so much!

<p align='center'><a href="https://paypal.me/lamnhan066">PayPal</a></p>
<p align='center'><a href="https://www.buymeacoffee.com/vursin"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=vursin&button_colour=5F7FFF&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00" width="200"></a></p>

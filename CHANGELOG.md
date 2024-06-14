## 0.5.2

* Fixes issue when the `workerFunction` is empty in an available Worker isolate.

## 0.5.1

* Fixes issue that the temp files is not removed while generating.

## 0.5.0

* Bump sdk version to `^3.3.0`.
* Add a generator to generate the Worker by using the `@isolatesHelperWorker` annotation.
* Bump `isolate_manager` to `v5.0.1`.
* **BREAKING CHANGE:** All `Worker`s MUST be re-compiled to support this version. Recommend using the generator.

## 0.4.3+1

* Fix TYPO in the descriptions.
* Update README.

## 0.4.3

* Bump the `Isolate_Manager` to `v4.3.0`.
* Improve the `IsolatesHelper.workerFunction`.
* Improve the tests with the `Worker`.

## 0.4.2+1

* Add `IsolatesHelper.workerFunction` (See more in README).
* Update tests to improve the code coverage.
* Update README.

## 0.4.1

* Update homepage URL.
* Update comments.

## 0.4.0

* Update `worker.dart` with a new format to make it easier to use.
* Add `workerFunction`, `workerParams` to execute a mapped function when using `Worker`.

## 0.3.0

* Remove type of the `IsolatesHelper`.
* The return type and parameter type of the `compute` method automatically respect the type of the `function`.

## 0.2.1

* Add `ensureStarted` and `isStarted` to check if the current isolates are started or still in processing.

## 0.2.0

* Bump `isolate_manager` to `^3.0.0`.

## 0.1.1

* Improve README.

## 0.1.0

* Bumped Dart sdk to `>=2.18.0 <4.0.0`.

## 0.0.3

* Improve test for `try-catch` block.
* Improve REAME for `try-catch` block.

## 0.0.2+1

* Add `@pragma('vm:entry-point')` anotation.

## 0.0.2

* Add `stream` method to listen to result events.
* Update example to show how to use `stream` method.

## 0.0.1

* Initial release.

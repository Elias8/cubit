<img src="https://raw.githubusercontent.com/felangel/cubit/master/assets/cubit_test_full.png" height="80" alt="Cubit Test" />

[![Pub](https://img.shields.io/pub/v/cubit_test.svg)](https://pub.dev/packages/cubit_test)
[![build](https://github.com/felangel/cubit/workflows/build/badge.svg)](https://github.com/felangel/cubit/actions)
[![coverage](https://github.com/felangel/cubit/blob/master/packages/cubit_test/coverage_badge.svg)](https://github.com/felangel/cubit/actions)

**WARNING: This is highly experimental**

A Dart package that makes testing cubits easy. Built to work with [cubit](https://pub.dev/packages/cubit) and [mockito](https://pub.dev/packages/mockito).

## Create a Mock Cubit

```dart
import 'package:cubit_test/cubit_test.dart';

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}
```

## Stub the Cubit Stream

**whenListen** creates a stub response for the `listen` method on a `Cubit`. Use `whenListen` if you want to return a canned `Stream` of states for a cubit instance. `whenListen` also handles stubbing the `state` of the cubit to stay in sync with the emitted state.

```dart
// Create a mock instance
final counterCubit = MockCounterCubit();

// Stub the cubit `Stream`
whenListen(counterCubit, Stream.fromIterable([0, 1, 2, 3]));

// Assert that the cubit emits the stubbed `Stream`.
await expectLater(counterCubit, emitsInOrder(<int>[0, 1, 2, 3])))

// Assert that the cubit's current state is in sync with the `Stream`.
expect(counterCubit.state, equals(3));
```

## Unit Test a Real Cubit with cubitTest

**cubitTest** creates a new `cubit`-specific test case with the given `description`. `cubitTest` will handle asserting that the `cubit` emits the `expect`ed states (in order) after `act` is executed. `cubitTest` also handles ensuring that no additional states are emitted by closing the `cubit` stream before evaluating the `expect`ation.

`build` should be used for all `cubit` initialization and preparation and must return the `cubit` under test as a `Future`.

`act` is an optional callback which will be invoked with the `cubit` under test and should be used to interact with the `cubit`.

`skip` is an optional `int` which can be used to skip any number of states. The default value is 1 which skips the `initialState` of the cubit. `skip` can be overridden to include the `initialState` by setting skip to 0.

`wait` is an optional `Duration` which can be used to wait for async operations within the `cubit` under test such as `debounceTime`.

`expect` is an optional `Iterable<State>` which the `cubit` under test is expected to emit after `act` is executed.

`verify` is an optional callback which is invoked after `expect` and can be used for additional verification/assertions. `verify` is called with the `cubit` returned by `build`.

```dart
group('CounterCubit', () {
  cubitTest(
    'emits [] when nothing is called',
    build: () async => CounterCubit(),
    expect: [],
  );

  cubitTest(
    'emits [1] when increment is called',
    build: () async => CounterCubit(),
    act: (cubit) async => cubit.increment(),
    expect: [1],
  );
});
```

`cubitTest` can also be used to `skip` any number of emitted states before asserting against the expected states. The default value is 1 which skips the `initialState` of the cubit. `skip` can be overridden to include the `initialState` by setting skip to 0.

```dart
cubitTest(
  'CounterCubit emits [0, 1] when increment is called',
  build: () async => CounterCubit(),
  act: (cubit) async => cubit.increment(),
  skip: 0,
  expect: [0, 1],
);
```

`cubitTest` can also be used to wait for async operations like `debounceTime` by providing a `Duration` to `wait`.

```dart
cubitTest(
  'CounterCubit emits [1] when increment is called',
  build: () async => CounterCubit(),
  act: (cubit) async => cubit.increment(),
  wait: const Duration(milliseconds: 300),
  expect: [1],
);
```

`cubitTest` can also be used to `verify` internal cubit functionality.

```dart
cubitTest(
  'CounterCubit emits [1] when increment is called',
  build: () async => CounterCubit(),
  act: (cubit) async => cubit.increment(),
  expect: [1],
  verify: (_) async {
    verify(repository.someMethod(any)).called(1);
  }
);
```

**Note:** when using `cubitTest` with state classes which don't override `==` and `hashCode` you can provide an `Iterable` of matchers instead of explicit state instances.

```dart
cubitTest(
  'emits [StateB] when emitB is called',
  build: () async => MyCubit(),
  act: (cubit) async => cubit.emitB(),
  expect: [isA<StateB>()],
);
```

## Dart Versions

- Dart 2: >= 2.7.0

## Maintainers

- [Felix Angelov](https://github.com/felangel)

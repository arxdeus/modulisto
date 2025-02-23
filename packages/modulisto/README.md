# Modulisto

A advanced state management system that based on the concepts of `Trigger` and `Store`, which are handled by `Pipeline.sync` and `Pipeline.async`

# Quick Start

### 1. Create a module that `extends Module`
```dart
class SimpleCounter extends Module {
    ...
}
```
### 2. Declare in this module a `Trigger`s and `Stores` that you will use and link them using `Pipeline`
```dart
  late final state = Store(this, 0);

  // Generic <()> means that trigger doesn't have any payload
  late final increment = Trigger<()>(this);
  late final decrement = Trigger<()>(this);

  // Trigger can be private to describe some internal functionality
  late final _setValue = Trigger<int>(this);

  late final _pipeline = Pipeline.sync(
    this,
    ($) => $
      /// Schema of linkage look like:
      /// $..[type_of_linker].[type_of_subscription]
      ..unit(increment).bind((context, _) => context.update(state, state.value + 1))
      /// [context] allow us to modify any `Store<T>` value
      ..unit(decrement).bind((context, _) => context.update(state, state.value - 1))
      /// [value] is payload of [_setValue] Trigger
      ..unit(_setValue).bind((context, value) => context.update(state, value))
      /// `redirect` allow us to do some actions without context and modifications of the `Store<T>`
      /// tear-off omitted for readability
      ..unit(state).redirect((value) => print(value)),
  );
```

### 3. Initialize module and create subscriptions with `Module.initialize` in constructor body
```dart
SimpleCounter(...) {
    Module.initialize(
        this,
        /// [attach] bind each passed pipeline onto this module and ensures that pipeline isn't double linked
        attach: {
          pipeline,
        },
    );
}
```

### 4. Use newly created module in your project
```dart
final counter = SimpleCounter(...);

counter.increment(); // 1
counter.increment(); // 2

counter.decrement() // 1
```

# Entities

## `Unit`

An abstract, observable entity that encapsulates the relationship between modules and their ability to produce meaningful intention, denoted as `[Unit]Intent`, which describes the purpose or objective associated with the `Unit`

Any `Unit` is also `Stream` so, it can be provided in third-party solutions without any steps

## `Store<T>`

A subtype of the `Unit` that represents a holder/storage/container for `T` value

## `StoreView<T>`

Immutable view of `Store<T>` that discards possibility of updates

`StoreView`'s may sounds like `computed`, since it can listen source (parent) Store and mutate inner value

At the moment there's exists only two subtypes of `StoreView`: `Store` (itself), `MappedStoreView<T, F>`


### MappedStoreView<T, F>

You can get it by `.map` onto existing `Store<T>`

Allows you to listen parent `Store` and map all newcoming values with special `mapper` function

Value maps lazily, that means that first read of updated value will execute `mapper` function and cache the result. If the value was changed, then newcoming read will execute `mapper` again and cache value. No unneccessary `mapper` execution at all, only on first read of `.value`

## `Trigger<T>`

A subtype of the `Unit` that represents a unary (synchronous) call.

When the `.call` method is invoked (with the appropriate payload of type `T`), it notifies all `Unit` listeners with new value

`Trigger`'s eliminates the need to create custom `Event` classes, as is done in the `bloc`.


## `Pipeline`

`Modulisto` uses two ways of using `Pipeline`'s, each one can be created using the appropriate factory provided by `Pipeline`:
1. Synchronous pipeline - `Pipeline.sync`
2. Asynchronous pipeline - `Pipeline.async`

### `Pipeline.sync`

Used to subscribe `Unit`s or `Stream`s to synchronous callbacks that doesn't returns anything (`void`)

Under the hood, `Pipeline.sync` does not utilize any form of pipelining, so each callback is executed synchronously as reaction to the `Unit`

Can be used for debugging purposes or cross-invokation other `Trigger`'s

### `Pipeline.async`

Used to subscribe to `Unit`s or `Stream`s and reacts to it in `.bind/.redirect` way

Each such `Pipeline` passes through an internal `StreamController` (shared for all events in `Module`) and is processed according to the provided `transformer`

Any `EventTransformer` used in a `bloc` or (delivered via `bloc_concurrency`) can be used here in the same manner

__TL;DR__: `Pipeline.async` - _Grouped subscriptions to specific Stream's that allow us to use `PipelineContext`_






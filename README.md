# Modulisto Workspace

**Modulisto** is a modular, extensible state management and workflow library for Dart and Flutter.

It provides a robust foundation for building scalable applications with complex state flows, supporting both synchronous and asynchronous event pipelines.

---

## Table of Contents

- [Overview](#overview)
- [Packages](#packages)
  - [modulisto](#modulisto)
  - [modulisto_flutter](#modulisto_flutter)
- [Getting Started](#getting-started)
- [Example Usage](#example-usage)
- [Architecture](#architecture)
  - [Core Concepts](#core-concepts)
    - [Unit](#unit)
    - [Store](#store)
    - [Trigger](#trigger)
    - [Pipeline](#pipeline)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Modulisto enables you to build modular applications by organizing logic into **Modules** that communicate via **Triggers**, manage state with **Stores**, and orchestrate workflows using **Pipelines**.

The design is inspired by modern state management and event-driven architecture, making it suitable for both small and large-scale projects

---

## Packages

### modulisto

- **Description:** Advanced state management solution for Dart, supporting any number of event flows.
- **Platforms:** Dart (cross-platform)
- **Key Features:**
  - Modular state and workflow management
  - Reactive `Trigger<T>` and `Store<T>` system
  - Synchronous and asynchronous `Pipeline`'s
  - Observe functions using `Operation`

### modulisto_flutter

- **Description:** Flutter integration for Modulisto, providing adapters and widgets for seamless UI updates.
- **Platforms:** Flutter (Android, iOS, Web, Desktop)
- **Key Features:**
  - `ModuleScope` for widget lifecycle management
  - `StoreBuilder` for reactive UI updates
  - Adapters for `ValueListenable` and `Listenable`

---

## Glossary

- **`Module`:** Main building block for feature isolation that encapsulates `Store<T>`'s, `Trigger<T>`'s, and `Pipeline`'s.
- **`Store<T>`:** Type-safe, observable state holder. Supports collections (`ListStore`, `MapStore`) and computed views.
- **`Trigger<T>`:** Event dispatcher for actions, eliminating the need for custom event classes.
- **`Pipeline`:** Workflow runner that chains operations in response to triggers or state changes. Supports both sync and async flows.
- **`UnitAdapter`:** Bridge between `Unit`'s and external systems (e.g., streams, listenables).

---

## Getting Started

### Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  modulisto: ^3.0.0
  modulisto_flutter: ^2.2.0 # For Flutter projects
```

### Basic Usage

#### 1. **Create a module that extends Module**

```dart
class SimpleCounter extends Module {
    ...
}
```

#### 2. **Declare a Triggers and Stores and link them using Pipeline:**

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

#### 3.  **Initialize module using `Module.initialize`:**

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

4. **Use in your code:**

```dart
final counter = SimpleCounter(...);

counter.increment(); // 1
counter.increment(); // 2

counter.decrement() // 1
```

or

```dart
final counter = CounterModule();

Wigdet build(BuildContext context)
  =>
    StoreBuilder(
      store: counter.state,
      builder: (context, value) => Text('Count: $value'),
    );
```

---

## Example

### Simple Counter Example

```dart
final class TestModule extends Module {
  late final increment = Trigger<()>(this, debugName: 'increment');
  late final state = Store(this, 0, debugName: 'state');
  late final counterPipeline = Pipeline.async(
    this,
    debugName: 'counterPipeline',
    ($) => $
      ..unit(increment).bind((mutate, _) => mutate(state).patch((value) => value + 1)),
    transformer: eventTransformers.sequental,
  );

  TestModule() {
    Module.initialize(this, attach: { counterPipeline });
  }
}

void main() {
  final module = TestModule();
  module.increment();
}
```

See more in [`example/bin/`](example/bin/).

---

## Architecture

### Data Flow

The data flow in `Modulisto` is as follows:

| **Component**       | **Description**                          | **Flow**          |
|---------------------|------------------------------------------|-------------------|
| External Events/UI  | User or system events                    | → Triggers        |
| Triggers            | Dispatch actions                         | → Pipelines       |
| Pipelines           | Orchestrate logic                        | → Stores          |
| Stores              | Hold and update state                    | → UI/Exports      |
| UI/Exports          | React to state changes                   |                   |


### Core Concepts

### Unit
**`Unit<T>`** - low-level abstraction that incapsulates reactivity under the hood

**Key Features:**
- Abstraction that you must know, but should not use directly (only for advanced users)
- Represents any data-flow (from external, to external or bidirectional)
- Can be marked with `debugName`

### Trigger
**`Trigger<T>`** - `Unit<T>` that dispatches events into pipelines

**Key Features:**
- User interaction main entrypoint
- "button" that `trigger`'s `Pipeline` workflow

**Example:**
```dart
final increment = Trigger<()>(module, debugName: 'increment');
```

### Store
**`Store<T>`** - `Unit<T>` that manages typed state with support for collections and reactive updates

**Key Features:**
- Type-safe container for value
- Can be modified with `MutatorContext`
- Built-in collection support (`ListStore`, `MapStore`)
- Reactive value propagation

**Example:**
```dart
late final counter = Store<int>(
  module,
  initialState: 0,
  debugName: 'Counter',
);
```

### Pipeline
**`Pipeline`** orchestrates **`Module`** workflows, allows to `bind` many listenable/observable objects in your workflow

**Key Features:**
- Modular operation chaining
- Can transform flow via `.async` factory

**Example:**
```dart
final pipeline = Pipeline.async(
  module,
  ($) => $
    ..unit(increment).bind((mutate, _) => mutate(counter).patch((v) => v + 1)),
);
```

---

## Best Practices

- Always use generics for `Trigger<T>` and `Store<T>` (and their descendants) for type safety.
- Always provide `debugName` for easier debugging and tracing.
- Separate frequently changing parameters of state model into `Store<T>`'s
- Use `ModuleScope` in Flutter to bound lifecycle of modules to `Widget` lifecycle

---

## Contributing

Contributions are welcome! Open issues or pull requests on [GitHub](https://github.com/arxdeus/modulisto).

Please, ensure that your Pull Request's code matches `analysis_options.yaml` ruleset

Don't forget to star this repository, thank you for your support!

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---


import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/unit/trigger.dart';

@internal

/// Internal mixin for managing operation execution and triggering callbacks
base mixin OperationRunner {
  /// Map of functions to their associated triggers for operation completion
  @internal
  static final $operationRunners = <Function, Trigger<Object?>>{};

  /// Executes an operation and notifies registered triggers with the result
  ///
  /// [sourceFunction] is the function being executed
  /// [callback] is the function to run and return a Future result
  @protected
  Future<T> runAsOperation<T>(
    Function sourceFunction,
    Future<T> Function() callback,
  ) =>
      callback().then((value) {
        $operationRunners[sourceFunction]?.call(value);
        return value;
      });
}

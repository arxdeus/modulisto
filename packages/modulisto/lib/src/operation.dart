import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/unit/trigger.dart';

@internal
base mixin OperationRunner {
  @internal
  static final $operationRunners = <Function, Trigger<Object?>>{};

  @protected
  // ignore: non_constant_identifier_names
  Future<T> Operation<T>(
    Function sourceFunction,
    Future<T> Function() callback,
  ) =>
      callback().then((value) {
        $operationRunners[sourceFunction]?.call(value);
        return value;
      });
}

import 'package:meta/meta.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/trigger.dart';

@internal
typedef OperationRunnerMap = Map<Symbol, Trigger<Object?>>;

@internal
base mixin OperationRunner on ModuleBase {
  @internal
  static final operationRunners = Expando<OperationRunnerMap>('operationRunners');

  @protected
  // ignore: non_constant_identifier_names
  Future<T> Operation<T>(Symbol operationId, Future<T> Function() callback) async {
    final result = await callback();
    final operationsMap = operationRunners[this];
    final relevantTrigger = operationsMap?[operationId];
    relevantTrigger?.call(result);
    return result;
  }
}

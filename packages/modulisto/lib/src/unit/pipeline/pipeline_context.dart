import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

/// Base class for pipeline mutation contexts.
/// Used for managing mutation and disposal of units within pipelines.
@internal
abstract base class PipelineContextBase implements MutatorContext, Disposable {
  /// Returns a [Mutator] for the given [Mutable].
  @override
  Mutator<M> call<M extends Mutable>(M unit) => Mutator(unit);
}

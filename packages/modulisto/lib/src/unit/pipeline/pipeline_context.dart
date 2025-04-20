import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

@internal
abstract base class PipelineContextBase implements MutatorContext, Disposable {
  @override
  Mutator<M> call<M extends Mutable>(M unit) => Mutator(unit);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

/// Wrapper around [ValueUnit] that implements [ValueListenable].
///
/// Allows [ValueUnit] to be used with Flutter's [ValueListenableBuilder] and similar APIs.
class ValueListenableAdapter<T> extends ListenableAdapter implements ValueListenable<T> {
  /// Creates a [ValueListenableAdapter] for the given [ValueUnit].
  ValueListenableAdapter(this._unit) : super(_unit);

  /// The underlying [ValueUnit] that being adapted.
  final ValueUnit<T> _unit;

  /// The current value of the [ValueUnit].
  @override
  T get value => _unit.value;
}

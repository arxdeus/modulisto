import 'package:flutter/foundation.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

class ValueListenableAdapter<T> extends ListenableAdapter implements ValueListenable<T> {
  ValueListenableAdapter(this.unit) : super(unit);

  final ValueUnit<T> unit;

  @override
  T get value => unit.value;
}

import 'package:flutter/foundation.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

import 'package:modulisto_flutter/src/value_listenable_adapter.dart';

extension UnitToListenable<T> on UnitAdapter<Unit<T>> {
  /// Wraps the [unit] with [ListenableAdapter] and returns as [Listenable]
  Listenable toListenable() => ListenableAdapter(unit);
}

extension StoreToValueListenable<T> on UnitAdapter<Store<T>> {
  /// Wraps the [unit] with [ValueListenableAdapter] and returns as [ValueListenable<T>]
  ValueListenable<T> toValueListenable() => ValueListenableAdapter(unit);
}

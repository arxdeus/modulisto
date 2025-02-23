import 'package:flutter/foundation.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

import 'package:modulisto_flutter/src/value_listenable_adapter.dart';

extension UnitToListenable<T> on UnitAdapter<Unit<T>> {
  Listenable toListenable() => ListenableAdapter(unit);
}

extension StoreToValueListenable<T> on UnitAdapter<Store<T>> {
  ValueListenable<T> toValueListenable() => ValueListenableAdapter(unit);
}

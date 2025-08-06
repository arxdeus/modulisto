import 'package:pureflow/src/core/listenable.dart';

class TriggerListenable<T> with ChangeNotifier implements ValueListenable<T> {
  TriggerListenable(this._value);

  T _value;
  T get value => _value;

  void call(T value) {
    _value = value;
    notifyListeners();
  }
}

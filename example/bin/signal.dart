import 'package:modulisto/modulisto.dart';

final class SignalModule extends Module {
  late final Trigger<({int test})> trigger = Trigger(this);
  late final Store<int> store = Store(this, 0);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..redirect(store, print)
      ..bind(
        trigger,
        (context, ({int test}) value) {
          context.updateStore(store, value.test);
        },
      ),
  );

  SignalModule() {
    Module.initialize(
      this,
      (ref) => ref..attach(_pipeline),
    );
  }
}

void main(List<String> args) {
  final module = SignalModule();
  module.trigger((test: 228));
}

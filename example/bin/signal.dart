import 'package:modulisto/modulisto.dart';

abstract class TestInterface {
  Future<int> someNumber(int test);
}

abstract class RootInterface {
  Future<String> someString(String test);
}

final class RootModule extends Module implements RootInterface {
  RootModule();

  @override
  Future<String> someString(String test) => runAsOperation(someString, () async => test);
}

final class SignalModule extends Module implements TestInterface {
  final RootInterface rootInterface;

  late final Trigger<({int test})> trigger = Trigger(this);
  late final store = Store(this, 0);
  late final listState = ListStore(this, <int>[]);
  late final mapState = MapStore(this, <int, String>{});

  Future<void> _update(MutatorContext mutate, ({int test}) value) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    mutate(listState).add(value.test);
    mutate(mapState).setKeyValue(123, '');
  }

  Stream<int> testStream() async* {
    yield 1;
    yield 2;
    return;
  }

  late final _syncPipeline = Pipeline.sync(this, ($) => $..unit(store).redirect(print));

  @override
  Future<int> someNumber(int test) => runAsOperation(someNumber, () async => test);
  Future<int> someNumber2(int test2) => runAsOperation(someNumber2, () async => test2);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..unit(trigger).bind(_update)
      ..stream(testStream()).redirect(print)
      ..operationOnType<String>(rootInterface.someString)
          .redirect((value) => print('from root interface: $value')),
    transformer: eventTransformers.sequental,
  );

  SignalModule(this.rootInterface) {
    Module.initialize(
      this,
      attach: {
        _syncPipeline,
        _pipeline,
      },
    );
  }
}

void main(List<String> args) async {
  ModulistoSettings.debugReportOperationTypeMismatch = true;

  final rootModule = RootModule();
  final module = SignalModule(rootModule);

  await rootModule.someString('123');

  module.trigger((test: 228));

  // final number = await module.someNumber2(44);
  // module.trigger((test: number));
}

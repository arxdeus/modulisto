import 'package:modulisto/modulisto.dart';
import 'package:modulisto/src/operation.dart';
import 'package:test/test.dart';

import 'util/dummy_module.dart';

void main() {
  group('operation tests', () {
    test('react on operation', () async {
      const targetNumber = 123;
      final dummy = DummyModule();
      final trigger = Trigger<int>(dummy);
      final store = Store<int>(dummy, 0);

      Future<int> someNumber(int test) => dummy.runOperation(someNumber, () => Future.value(test));

      final pipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(
            (mutate, value) => mutate(store).set(value),
          )
          ..operationOnType<int>(someNumber).redirect(trigger.call),
      );

      Module.initialize(dummy, attach: {pipeline});

      final number = await someNumber(targetNumber);
      expect(number, targetNumber);
      expect(number, isNot(0));
      expect(number, equals(store.value));
    });
    test('disable reactions after module dispose', () async {
      const targetNumber = 123;
      final dummy = DummyModule();
      final trigger = Trigger<int>(dummy);
      final store = Store<int>(dummy, 0);

      Future<int> someNumber(int test) => dummy.runOperation(someNumber, () => Future.value(test));

      final pipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(
            (mutate, value) => mutate(store).set(value),
          )
          ..operationOnType<int>(someNumber).redirect(trigger.call),
      );

      Module.initialize(dummy, attach: {pipeline});

      await dummy.dispose();

      final number = await someNumber(targetNumber);
      expect(number, targetNumber);
      expect(store.value, isNot(number));
      expect(store.value, equals(0));
    });
    test('ensure that internal triggers of operation are disposed after module dispose', () async {
      final dummy = DummyModule();

      // ignore: unused_element
      Future<int> test1(int test) => dummy.runOperation(test1, () => Future.value(test));

      final pipeline = Pipeline.sync(
        dummy,
        ($) => $..operationOnType<int>(test1).redirect((_) {}),
      );

      Module.initialize(dummy, attach: {pipeline});

      await dummy.dispose();

      expect(dummy.isClosed, isTrue);
      expect(OperationRunner.$operationRunners[test1], isNull);
    });
  });
}

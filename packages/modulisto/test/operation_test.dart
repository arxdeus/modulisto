import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/dummy_module.dart';

void main() {
  group('operation tests', () {
    test('react on operation', () async {
      const targetNumber = 123;
      final dummy = DummyModule();
      final trigger = Trigger<int>(dummy);
      final store = Store<int>(dummy, 0);

      Future<int> someNumber(int test) => dummy.runOperation(#test1, () => Future.value(test));

      final pipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(
            (context, value) => context.update(store, value),
          )
          ..operationOnType<int>(#test1).redirect(trigger.call),
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

      Future<int> someNumber(int test) => dummy.runOperation(#test1, () => Future.value(test));

      final pipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(
            (context, value) => context.update(store, value),
          )
          ..operationOnType<int>(#test1).redirect(trigger.call),
      );

      Module.initialize(dummy, attach: {pipeline});

      await dummy.dispose();

      final number = await someNumber(targetNumber);
      expect(number, targetNumber);
      expect(store.value, isNot(number));
      expect(store.value, equals(0));
    });
  });
}

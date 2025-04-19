import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/dummy_module.dart';
import 'util/mock_module.dart';

void main() {
  group('[trigger basic functionality]', () {
    test('trigger invocation in `PipelineCallback` works fine', () async {
      final dummy = DummyModule();
      final marker = Store<int>(dummy, 0);
      final trigger = Trigger<int>(dummy);

      // ignore: avoid_positional_boolean_parameters
      void markAsDone(MutatorContext mutate, int markValue) {
        final oldValue = marker.value;
        final newValue = oldValue + 1;
        mutate(marker).set(newValue);
        expect(marker.value, newValue);

        if (marker.value > 3) {
          expect(newValue, equals(4));
          return;
        }

        trigger(newValue);
      }

      late final defaultPipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(markAsDone)
          ..unit(dummy.lifecycle.init).redirect((_) => trigger(0)),
      );

      Module.initialize(
        dummy,
        attach: {defaultPipeline},
      );
    });
    test('out-of-module invokation', () {
      final module = createModule(eventTransformer: eventTransformers.concurrent);
      expect(module.increment.call, returnsNormally);
    });
    test('validate no-sideeffects if trigger was not linked', () {
      final module = createModule(eventTransformer: eventTransformers.concurrent);
      expect(module.increment.call, returnsNormally);
      expectLater(module.state.value, equals(0));
    });
    test('trigger created in runtime wont do anything', () {
      final module = createModule(eventTransformer: eventTransformers.concurrent);
      final trigger = Trigger<()>(module);
      expect(trigger.call, returnsNormally);
    });
    test('validate sideeffects if trigger was linked', () async {
      final module = createModule(eventTransformer: eventTransformers.concurrent);
      const countOfIncrement = 4;
      for (var i = 0; i < countOfIncrement; i++) {
        module.increment();
      }
      expect(module.state.value, isZero);
      await Future<void>.delayed(Duration.zero);
      expect(module.state.value, equals(countOfIncrement));
    });
  });
}

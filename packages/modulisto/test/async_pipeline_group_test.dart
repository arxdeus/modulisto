import 'package:fake_async/fake_async.dart';
import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/mock_module.dart';

void main() {
  group('[async pipeline group]', () {
    group('[transformers]', () {
      const defaultDuration = Duration(seconds: 1);
      const numberOfEmits = 4;

      void Function() transformerTest({
        required EventTransformer transformer,
        required Duration elapsedDuration,
        required int resultValue,
      }) =>
          () => fakeAsync((async) {
                final module = createModule(
                  eventTransformer: transformer,
                  delayBetweenEvents: defaultDuration,
                );
                for (var i = 0; i < numberOfEmits; i++) {
                  expect(module.increment.call, returnsNormally);
                }
                async.elapse(elapsedDuration);
                expect(module.state.value, equals(resultValue));
              });

      test(
        'sequental (default)',
        transformerTest(
          transformer: eventTransformers.sequental,
          elapsedDuration: defaultDuration * numberOfEmits,
          resultValue: numberOfEmits,
        ),
      );
      test(
        'droppable',
        transformerTest(
          transformer: eventTransformers.droppable,
          elapsedDuration: defaultDuration,
          resultValue: 1,
        ),
      );
      test(
        'restartable',
        transformerTest(
          transformer: eventTransformers.restartable,
          elapsedDuration: defaultDuration * numberOfEmits,
          resultValue: 2,
        ),
      );
      test(
        'concurrent',
        transformerTest(
          transformer: eventTransformers.concurrent,
          elapsedDuration: defaultDuration,
          resultValue: numberOfEmits,
        ),
      );
    });
  });
}

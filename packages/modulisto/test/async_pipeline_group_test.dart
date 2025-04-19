import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/mock_module.dart';

void main() {
  group('[async pipeline group]', () {
    void fuzzTestByCount(int numberOfEmits) =>
        group('[transformers] fuzzy emits: $numberOfEmits', () {
          const defaultDuration = Duration(seconds: 1);

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

    final rand = Random();

    /// Fuzz
    fuzzTestByCount(rand.nextInt(25));
    fuzzTestByCount(rand.nextInt(50));
    fuzzTestByCount(rand.nextInt(100));
    fuzzTestByCount(rand.nextInt(1000));
    fuzzTestByCount(rand.nextInt(1000) + 1000);
    fuzzTestByCount(rand.nextInt(1000) + 2000);
    fuzzTestByCount(rand.nextInt(1000) + 3000);
    fuzzTestByCount(rand.nextInt(1000) + 5000);
    fuzzTestByCount(rand.nextInt(1000) + 7000);
  });
}

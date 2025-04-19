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
              resultValue: numberOfEmits.clamp(1, 2),
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

    /// Fuzz
    final rand = Random();
    final randMax = List.generate(13, (i) => pow(2, i).toInt());
    randMax.map((value) => rand.nextInt(value) + value).forEach(fuzzTestByCount);
  });
}

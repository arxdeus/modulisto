import 'dart:math';

import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/mock_module.dart';

void main() {
  group('adapter test', () {
    Future<void> testStreamAdapter({bool shouldEmitImmediately = false}) async {
      final random = Random().nextInt(10) + 5;
      final module = createModule(
        eventTransformer: eventTransformers.sequental,
      );

      final stream = UnitAdapter(module.state).stream(
        emitFirstImmediately: shouldEmitImmediately,
      );
      final additive = shouldEmitImmediately ? 1 : 0;
      for (var i = 0; i < random - additive; i++) {
        module.increment();
      }
      final result = List.generate(random - additive, (i) => i + (1 - additive));
      expect(stream, emitsInOrder(result));
    }

    test(
      'stream adapter w/out ',
      () => testStreamAdapter(
        // ignore: avoid_redundant_argument_values
        shouldEmitImmediately: false,
      ),
    );
    test(
      'stream adapter w/ emit immediately',
      () => testStreamAdapter(
        shouldEmitImmediately: true,
      ),
    );
  });
}

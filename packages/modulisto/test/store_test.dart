import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/dummy_module.dart';

void main() {
  group('[store basic functionality]', () {
    group('mutate value', () {
      const targetValue = 228;

      final dummy = DummyModule();
      final state = Store<int>(dummy, 0);

      final linkedState = Store<String?>(dummy, null);
      final trigger = Trigger<int>(
        dummy,
      );

      late final syncPipeline = Pipeline.sync(
        dummy,
        ($) => $
          ..unit(trigger).bind(
            (context, value) => context.update(state, value),
          )
          ..unit(state).bind(
            (context, value) => context.update(linkedState, value.toString()),
          ),
      );

      Module.initialize(dummy, attach: {syncPipeline});

      test('feedback on trigger reaction', () async {
        expect(() => trigger(228), returnsNormally);
        await Future<void>.delayed(Duration.zero);
        expect(state.value, equals(targetValue));
      });

      test('feedback on state update (link one state to another state)', () {
        expect(linkedState.value, equals(targetValue.toString()));
      });
    });
  });
}

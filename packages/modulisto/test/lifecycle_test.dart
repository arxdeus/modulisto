import 'package:modulisto/modulisto.dart';
import 'package:test/test.dart';

import 'util/dummy_module.dart';

enum _Lifecycle {
  notInited,
  inited,
  disposed,
}

void main() {
  group('[lifecycle tests]', () {
    final dummy = DummyModule();

    final someCoolToggle = Store(dummy, 0);
    final pullToggle = Trigger<int>(dummy);
    var lifecycleState = _Lifecycle.notInited;

    void update(PipelineContext context, int value) {
      print('lol');
      context.update(someCoolToggle, value);
    }

    late final anotherPipeline = Pipeline.sync(
      dummy,
      ($) => $..unit(pullToggle).bind(update),
    );

    late final syncPipeline = Pipeline.sync(
      dummy,
      ($) => $
        ..unit(dummy.lifecycle.init).redirect((_) => lifecycleState = _Lifecycle.inited)
        ..unit(dummy.lifecycle.init).redirect((_) => pullToggle(1))
        ..unit(dummy.lifecycle.dispose).redirect((_) => lifecycleState = _Lifecycle.disposed),
    );

    Module.initialize(
      dummy,
      attach: {
        syncPipeline,
        anotherPipeline,
      },
    );

    test('lifecycle init groups worked', () async {
      expect(lifecycleState, equals(_Lifecycle.inited));
      expect(someCoolToggle.value, equals(1));
    });

    test('lifecycle dispose internal trigger', () async {
      expect(lifecycleState, equals(_Lifecycle.inited));
      await expectLater(dummy.dispose, returnsNormally);
      expect(lifecycleState, equals(_Lifecycle.disposed));
    });

    test('all subscriptions are removed after dispose', () async {
      final oldValue = someCoolToggle.value;
      final newValue = oldValue + 1;

      expect(() => pullToggle(newValue), returnsNormally);
      expect(someCoolToggle.value, equals(oldValue));
    });
  });
}

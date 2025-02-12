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

    late final anotherPipeline = Pipeline.sync(
      dummy,
      ($) => $
        ..bind(
          pullToggle,
          (context, value) => context.updateStore(someCoolToggle, value),
        ),
    );

    late final syncPipeline = Pipeline.sync(
      dummy,
      ($) => $
        ..redirect(dummy.lifecycle.init, (_) => lifecycleState = _Lifecycle.inited)
        ..redirect(dummy.lifecycle.init, (_) => pullToggle(1))
        ..redirect(dummy.lifecycle.dispose, (_) => lifecycleState = _Lifecycle.disposed),
    );

    Module.initialize(
      dummy,
      (ref) => ref
        ..attach(syncPipeline)
        ..attach(anotherPipeline),
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

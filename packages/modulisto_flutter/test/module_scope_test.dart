import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

import 'util/test_util.dart';

base class DummyWithStore extends DummyModule {
  late final Trigger<int> trigger = Trigger(this);
  late final Store<int> state = Store(this, 0);

  late final _pipeline = Pipeline.sync(
    this,
    ($) => $..unit(trigger).bind(_updateState),
  );

  void _updateState(MutatorContext mutate, int value) => mutate(state).set(value);

  DummyWithStore() {
    Module.initialize(
      this,
      attach: {
        _pipeline,
      },
    );
  }
}

void main() {
  group('module scope', () {
    testWidgets('module is findable by mutate', (tester) async {
      final module = DummyWithStore();
      await tester.pumpWidget(
        TestUtil.appContext(
          child: ModuleScope<DummyWithStore>.value(
            module: module,
            child: StoreBuilder(
              unit: module.state,
              builder: (mutate, state, child) => Text('$state'),
            ),
          ),
        ),
      );
      final mutate = tester.firstElement(find.byType(StoreBuilder<int>));
      final moduleFromContext = ModuleScope.of<DummyWithStore>(mutate);
      expect(module, same(moduleFromContext));
      expect(
        module,
        isA<DummyWithStore>().having((c) => c.state.value, 'state', equals(0)),
      );

      module.trigger(1);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
      expect(
        module,
        isA<DummyWithStore>().having((c) => c.state.value, 'state', equals(1)),
      );
    });
  });
}

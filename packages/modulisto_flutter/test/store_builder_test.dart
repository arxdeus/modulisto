import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';

import 'util/test_util.dart';

final class DummyModule extends Module {}

void main() {
  (Store<int>, Trigger<()>) createSignal() {
    final dummy = DummyModule();
    final trigger = Trigger<()>(dummy);
    final store = Store(dummy, 0);
    final pipeline =
        Pipeline.async(dummy, ($) => $..unit(trigger).bind((context, _) => context.update(store, store.value + 1)));
    dummy.attach(pipeline);
    return (store, trigger);
  }

  group('store builder', () {
    testWidgets('store builder builds', (tester) async {
      final (store, trigger) = createSignal();

      await tester.pumpWidget(
        TestUtil.appContext(
          child: StoreBuilder(
            store: store,
            builder: (_, value, __) => Text(value.toString()),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      trigger();

      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOne);
    });
  });
}

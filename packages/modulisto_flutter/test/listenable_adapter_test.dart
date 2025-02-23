import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

import 'util/test_util.dart';

void main() {
  (Listenable, Trigger<()>) createListenableAdapter() {
    final dummy = DummyModule();
    final trigger = Trigger<()>(dummy);
    final listenable = ListenableAdapter(trigger);
    return (listenable, trigger);
  }

  group('listenable adapter', () {
    test('test subscriptions', () {
      var isListenableCalled = false;
      final (listenable, trigger) = createListenableAdapter();
      listenable.addListener(() => isListenableCalled = !isListenableCalled);

      trigger();
      expect(isListenableCalled, isTrue);
    });

    testWidgets('listenable builder builds', (tester) async {
      var counter = 0;
      final (listenable, trigger) = createListenableAdapter();

      listenable.addListener(() {
        counter = counter + 1;
      });

      await tester.pumpWidget(
        TestUtil.appContext(
          child: ListenableBuilder(
            listenable: listenable,
            builder: (_, __) => Text(counter.toString()),
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

// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:math';

import 'package:modulisto/modulisto.dart';
import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:test/test.dart';

import 'util/mock_module.dart';

void main() {
  group('adapter test', () {
    Future<void> testStreamAdapter({bool shouldEmitImmediately = false}) async {
      final random = Random().nextInt(10) + 5;
      final module = createModule(
        eventTransformer: eventTransformers.sequental,
        // delayBetweenEvents: Duration.zero,
      );
      final adapter = UnitAdapter(module.state);
      final stream = shouldEmitImmediately ? adapter.subject() : adapter.stream();
      final additive = shouldEmitImmediately ? 1 : 0;
      final result = List.generate(random - additive, (i) => i + (1 - additive));

      expect(stream, emitsInOrder(result));

      for (var i = 0; i < random - additive; i++) {
        module.increment();
      }
    }

    test('different stream adapters refers to the same controller under the hood', () {
      final module = createModule(eventTransformer: eventTransformers.sequental);

      final stream1 = UnitAdapter(module.state).stream();
      final stream2 = UnitAdapter(module.state).stream();
      final stream3 = UnitAdapter(module.stateX).stream();
      final stream4 = UnitAdapter(module.stateX).stream();

      expect(stream1, equals(stream2));
      expect(stream3, equals(stream4));
      expect(stream1, isNot(equals(stream4)));
    });

    test('different subject adapters refers to the same controller under the hood', () {
      final module = createModule(eventTransformer: eventTransformers.sequental);

      final stream1 = UnitAdapter(module.state).subject();
      final stream2 = UnitAdapter(module.state).subject();
      final stream3 = UnitAdapter(module.stateX).subject();
      final stream4 = UnitAdapter(module.stateX).subject();

      expect(stream1, equals(stream2));
      expect(stream3, equals(stream4));
      expect(stream1, isNot(equals(stream4)));
    });

    test('different trigger stream adapters refers to the same controller under the hood', () {
      final module = createModule(eventTransformer: eventTransformers.sequental);

      final stream1 = UnitAdapter(module.increment).stream();
      final stream12 = UnitAdapter(module.increment).stream();
      final stream2 = UnitAdapter(module.decrement).stream();
      final stream3 = UnitAdapter(module.reset).stream();

      expect(stream1, equals(stream12));
      expect(stream1, isNot(equals(stream2)));
      expect(stream1, isNot(equals(stream3)));
      expect(stream12, isNot(equals(stream3)));
    });

    test('ensure that features is cleared after module dispose', () async {
      final module = createModule(eventTransformer: eventTransformers.sequental);

      final _ = UnitAdapter(module.increment).stream();
      expect(UnitToStreamAdapter.$linkedControllers[module.increment], isNotNull);
      await module.dispose();
      expect(UnitToStreamAdapter.$linkedControllers[module.increment], isNull);
    });

    test('ensure that no new features created after module dispose', () async {
      final module = createModule(eventTransformer: eventTransformers.sequental);
      await module.dispose();
      final stream = UnitAdapter(module.increment).stream();
      expect(stream, emitsDone);
      expect(UnitToStreamAdapter.$linkedControllers[module.increment], isNull);
    });
    test('ensure that stream associated with unit is closed after module dispose', () async {
      final module = createModule(eventTransformer: eventTransformers.sequental);
      var isDone = false;
      final sub = UnitAdapter(module.increment).stream().listen(
            null,
            onDone: () => isDone = true,
          );
      final controller = UnitToStreamAdapter.$linkedControllers[module.increment];
      expect(controller?.isClosed, isFalse);
      expect(UnitToStreamAdapter.$linkedControllers[module.increment], isNotNull);
      await module.dispose();
      expect(UnitToStreamAdapter.$linkedControllers[module.increment], isNull);
      expect(isDone, isTrue);
      expect(controller?.isClosed, isTrue);
      unawaited(sub.cancel());
      unawaited(controller?.close());
    });
    test('ensure that subject associated with store is closed after module dispose', () async {
      final module = createModule(eventTransformer: eventTransformers.sequental);
      var isDone = false;
      final stream1 = UnitAdapter(module.state).subject();
      final sub = stream1.listen(
        null,
        onDone: () => isDone = true,
      );

      Subject<T>? featuresList<T>(ValueUnit<T> unit) =>
          ValueUnitUnitToStreamAdapter.linkedControllers[unit] as Subject<T>?;
      final controller = featuresList(module.state);
      expect(controller?.isClosed, isFalse);
      expect(featuresList(module.state), isNotNull);
      await module.dispose();
      expect(featuresList(module.state), isNull);
      expect(isDone, isTrue);
      expect(controller?.isClosed, isTrue);

      unawaited(sub.cancel());
      unawaited(controller?.close());
    });

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

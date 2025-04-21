import 'dart:async';
import 'dart:math';

import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:test/test.dart';

void main() {
  group('subject tests', () {
    test('multiple stream from subject not multiples emitted values', () {
      final random = Random().nextInt(10) + 5;
      final result = List.generate(random, (i) => i);
      final subject1 = Subject<int>(initialValue: 0);

      expect(subject1.stream, emitsInOrder(result));

      for (var i = 1; i < result.length; i++) {
        subject1.add(result[i]);
      }
      expect(subject1.stream, emitsInOrder([subject1.value, 999]));
      subject1.add(999);
      unawaited(subject1.close());
    });
  });
}

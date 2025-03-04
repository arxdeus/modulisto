import 'dart:math';

import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:test/test.dart';

void main() {
  group('subject tests', () {
    test('multiple stream from subject not multiples emitted values', () async {
      final random = Random().nextInt(10) + 5;
      final result = List.generate(random, (i) => i);
      final subject1 = Subject<int>(initialValue: 0);

      expect(subject1.stream, emitsInOrder(result));
      expect(subject1.stream, emitsInOrder(result));
      expect(subject1.stream, emitsInOrder(result));

      for (int i = 1; i < result.length; i++) {
        subject1.add(result[i]);
      }

      await Future(() {});
      expect(subject1.stream, emitsInOrder([subject1.value, 999]));
      subject1.add(999);
    });
  });
}

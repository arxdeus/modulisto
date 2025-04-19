import 'package:modulisto/modulisto.dart';

final class DummyModule extends Module {
  Future<T> runOperation<T>(Function operationId, Future<T> Function() callback) =>
      Operation(operationId, callback);
}

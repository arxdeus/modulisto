import 'dart:async';

final class ClosableStreamWrapper<T> extends Stream<T> {
  final StreamController<T> _parent;

  ClosableStreamWrapper(this._parent);

  void close() => _parent.close();

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _parent.stream.listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
}

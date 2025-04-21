import 'dart:async';

import 'package:meta/meta.dart';

@internal
class Subject<T> implements StreamController<T> {
  Subject({
    T? initialValue,
    FutureOr<void> Function()? onCancel,
    void Function()? onListen,
  })  : _value = initialValue,
        _parent = StreamController.broadcast(
          onListen: onListen,
          onCancel: onCancel,
        );

  late final StreamController<T> _parent;

  @override
  FutureOr<void> Function()? get onCancel => _parent.onCancel;
  @override
  set onCancel(FutureOr<void> Function()? callback) => _parent.onCancel = callback;

  @override
  void Function()? get onListen => _parent.onListen;
  @override
  set onListen(void Function()? callback) => _parent.onListen = callback;

  @override
  void Function()? get onPause => null;
  @override
  set onPause(void Function()? callback) {}

  @override
  void Function()? get onResume => null;
  @override
  set onResume(void Function()? callback) {}

  T? _value;
  T get value => _value ?? (throw StateError('No value observed yet'));
  T? get valueOrNull => _value;

  @override
  void add(T event) {
    _value = event;
    _parent.add(event);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) => _parent.addError(error, stackTrace);

  @override
  Future<void> addStream(Stream<T> source, {bool? cancelOnError}) =>
      _parent.addStream(source, cancelOnError: cancelOnError);

  @override
  Future<void> close() => _parent.close();

  @override
  Future<void> get done => _parent.done;

  @override
  bool get hasListener => _parent.hasListener;

  @override
  bool get isClosed => _parent.isClosed;

  @override
  bool get isPaused => _parent.isPaused;

  @override
  StreamSink<T> get sink => _parent.sink;

  Stream<T>? _stream;

  @override
  Stream<T> get stream => _stream ??= SubjectStream(this);
}

class SubjectStream<T> extends Stream<T> {
  final Subject<T> _subject;

  SubjectStream(
    this._subject,
  );

  Stream<T> get _realStream {
    final controller = StreamController<T>(sync: true);
    final value = _subject.value;
    if (value != null) controller.add(value);

    controller
        .addStream(_subject._parent.stream)
        .whenComplete(controller.close)
        .onError(controller.addError)
        .ignore();

    return controller.stream;
  }

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _realStream.listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
}

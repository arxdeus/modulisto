import 'dart:async';

import 'package:meta/meta.dart';

typedef ListenerCallback<T> = void Function(T data);

@internal
class SyncStreamController<T> implements SynchronousStreamController<T> {
  SyncStreamController({
    this.onListen,
    this.onCancel,
    this.onPause,
    this.onResume,
  });

  bool _isClosed = false;
  bool _isPaused = false;

  late final Completer _completer = Completer.sync();

  final _listeners = <ListenerCallback<T>, bool>{};

  @override
  FutureOr<void> Function()? onCancel;

  @override
  void Function()? onListen;

  @override
  void Function()? onPause;

  @override
  void Function()? onResume;

  @override
  void add(T event) {
    assert(!_isClosed, 'SyncStreamControlelr is closed');

    if (_isPaused) return;
    if (_listeners.isEmpty) return;
    if (_isClosed) return;

    _listeners.entries
        .where((entry) => entry.value)
        .forEach((listener) => listener.key(event));
  }

  @override
  Never addError(Object error, [StackTrace? stackTrace]) {
    _completer.completeError(error, stackTrace);
    throw stackTrace == null
        ? error
        : Error.throwWithStackTrace(error, stackTrace);
  }

  @override
  Future addStream(Stream<T> source, {bool? cancelOnError}) =>
      source.forEach((event) {
        try {
          add(event);
        } on Object {
          if (cancelOnError == true) {
            rethrow;
          }
        }
      });

  @override
  Future close() async {
    if (_completer.isCompleted) return;

    _completer.complete();
    _listeners.clear();
  }

  void _updateListenerState(ListenerCallback<T>? callback, bool state) {
    if (callback == null) return;
    if (!_listeners.containsKey(callback)) return;

    _listeners[callback] = state;
  }

  bool? _fetchListenerState(ListenerCallback<T>? callback) {
    if (callback == null) return null;
    if (!_listeners.containsKey(callback)) return null;

    return _listeners[callback];
  }

  @override
  Future get done => _completer.future;

  @override
  bool get hasListener => _listeners.isNotEmpty;

  @override
  bool get isClosed => _completer.isCompleted;

  @override
  bool get isPaused => _isPaused;

  @override
  late final StreamSink<T> sink = SyncEventStream(this);

  @override
  late final Stream<T> stream = SyncStream(this);
}

class SyncEventStream<T> implements StreamSink<T> {
  final SyncStreamController<T> _controller;

  SyncEventStream(this._controller);

  @override
  void add(T event) => _controller.add(event);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _controller.addError(error, stackTrace);

  @override
  Future addStream(Stream<T> stream) => _controller.addStream(stream);

  @override
  Future close() => _controller.close();

  @override
  Future get done => _controller.done;
}

bool typeAcceptsNull<T>() => (const <Null>[]) is List<T> || null is T;

@internal
class SyncStreamSubscription<T> implements StreamSubscription<T> {
  SyncStreamSubscription(
    this.controller,
    this.callback,
  );

  final SyncStreamController<T> controller;
  void Function(T event)? callback;

  @override
  Future<E> asFuture<E>([E? futureValue]) => controller.stream.last.then((_) {
        E resultValue;
        if (futureValue == null) {
          if (!typeAcceptsNull<E>()) {
            throw ArgumentError.notNull("futureValue");
          }
          resultValue = futureValue as dynamic;
        } else {
          resultValue = futureValue;
        }
        return resultValue;
      });

  @override
  Future<void> cancel() async {
    controller._listeners.remove(callback);
  }

  @override
  bool get isPaused => controller._fetchListenerState(callback) == false;

  @override
  void onData(void Function(T data)? handleData) {
    controller._listeners.remove(callback);
    callback = handleData;
    if (handleData case final handleData?) {
      controller._listeners[handleData] = true;
    }
  }

  @override
  void onDone(void Function()? handleDone) => throw UnsupportedError('');

  @override
  void onError(Function? handleError) => throw UnsupportedError('');

  @override
  void pause([Future<void>? resumeSignal]) {
    if (callback == null) return;

    controller._updateListenerState(callback, false);
    resumeSignal?.whenComplete(resume);
  }

  @override
  void resume() {
    if (callback == null) return;

    controller._updateListenerState(callback, true);
    controller.onResume?.call();
  }
}

@internal
class SyncStream<T> extends Stream<T> {
  final SyncStreamController<T> _controller;

  SyncStream(this._controller);

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (onData case final onData?) {
      _controller._listeners[onData] = true;
    }
    return SyncStreamSubscription(
      _controller,
      onData,
    );
  }
}

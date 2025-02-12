import 'package:flutter/widgets.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/listenable_adapter.dart';

/// {@template store_builder}
/// StoreBuilder widget.
/// {@endtemplate}
class StoreBuilder<T> extends StatefulWidget {
  /// {@macro store_builder}
  const StoreBuilder({
    required this.builder,
    required this.store,
    this.child,
    super.key, // ignore: unused_element
  });

  final Store<T> store;
  final ValueWidgetBuilder<T> builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  State<StoreBuilder<T>> createState() => _StoreBuilderState<T>();
}

/// State for widget StoreBuilder.
class _StoreBuilderState<T> extends State<StoreBuilder<T>> {
  @protected
  late ListenableAdapter _listenable = ListenableAdapter(widget.store);

  @override
  void didUpdateWidget(covariant StoreBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      _listenable = ListenableAdapter(widget.store);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _listenable,
        builder: (context, child) => widget.builder(context, widget.store.value, child),
        child: widget.child,
      );
}

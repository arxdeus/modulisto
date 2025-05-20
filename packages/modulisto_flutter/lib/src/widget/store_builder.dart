import 'package:flutter/widgets.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/value_listenable_adapter.dart';

/// A Flutter widget that rebuilds when the given [ValueUnit] changes.
class StoreBuilder<T> extends StatefulWidget {
  /// Creates a [StoreBuilder] for the given [ValueUnit] and builder function.
  const StoreBuilder({
    required this.unit,
    required this.builder,
    this.child,
    super.key, // ignore: unused_element
  });

  /// The [ValueUnit] to listen for changes.
  final ValueUnit<T> unit;

  /// The builder function that is called with the current value.
  final ValueWidgetBuilder<T> builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  State<StoreBuilder<T>> createState() => _StoreBuilderState<T>();
}

/// State for [StoreBuilder].
class _StoreBuilderState<T> extends State<StoreBuilder<T>> {
  @protected
  late ValueListenableAdapter<T> _listenable = ValueListenableAdapter(widget.unit);

  @override
  void didUpdateWidget(covariant StoreBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unit != widget.unit) {
      _listenable.clear();
      _listenable = ValueListenableAdapter(widget.unit);
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _listenable,
        builder: (context, value, child) => widget.builder(context, value, child),
        child: widget.child,
      );
}

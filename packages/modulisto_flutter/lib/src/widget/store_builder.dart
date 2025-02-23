import 'package:flutter/widgets.dart';
import 'package:modulisto/modulisto.dart';
import 'package:modulisto_flutter/src/value_listenable_adapter.dart';

/// {@template store_builder}
/// StoreBuilder widget.
/// {@endtemplate}
class StoreBuilder<T> extends StatefulWidget {
  /// {@macro store_builder}
  const StoreBuilder({
    required this.unit,
    required this.builder,
    this.child,
    super.key, // ignore: unused_element
  });

  final ValueUnit<T> unit;
  final ValueWidgetBuilder<T> builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  State<StoreBuilder<T>> createState() => _StoreBuilderState<T>();
}

/// State for widget StoreBuilder.
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

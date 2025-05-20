import 'package:flutter/material.dart';
import 'package:modulisto/modulisto.dart';

/// A Flutter widget that provides a [Module] to its descendants.
class ModuleScope<M extends Module> extends StatefulWidget {
  /// Creates a [ModuleScope] with a [create] function and a [child] widget.
  const ModuleScope({
    required this.create,
    required this.child,
    super.key,
  });

  /// Creates a [ModuleScope] with a given [module] instance and [child] widget.
  factory ModuleScope.value({
    required Widget child,
    required M module,
    Key? key,
  }) =>
      ModuleScope(
        key: key,
        create: (_) => module,
        child: child,
      );

  /// Function to create the [Module] instance.
  final M Function(BuildContext context) create;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Retrieve the current [M] from the widget tree
  static M of<M extends Module>(BuildContext context) =>
      _InheritedModuleScope.of<M>(context, listen: false);

  @override
  State<ModuleScope<M>> createState() => _ModuleScopeState<M>();
}

/// State class for [ModuleScope], managing the [Module] instance.
class _ModuleScopeState<M extends Module> extends State<ModuleScope<M>> {
  /// The [Module] instance created for this scope.
  late final M module = widget.create(context);

  @override
  Widget build(BuildContext context) => _InheritedModuleScope<M>(
        /// Provides the [module] to descendants via inherited widget.
        module: module,
        child: widget.child,
      );
}

/// Inherited widget that provides the module to descendants.
class _InheritedModuleScope<M> extends InheritedWidget {
  /// Creates an inherited widget with the given module and child.
  const _InheritedModuleScope({
    /// The [Module] instance to provide to descendants.
    required this.module,

    /// The widget below this widget in the tree.
    required super.child,
  });

  /// The [Module] instance provided through the widget tree.
  final M module;

  /// Retrieves the [module] if available, otherwise returns null.
  static M? maybeOf<M extends Module>(BuildContext context, {bool listen = true}) => (listen
          ? context.dependOnInheritedWidgetOfExactType<_InheritedModuleScope<M>>()
          : context.getInheritedWidgetOfExactType<_InheritedModuleScope<M>>())
      ?.module;

  /// Gets the [module] from the widget tree, throwing an error if not found.
  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _InheritedModuleScope of the exact type',
        'out_of_scope',
      );

  /// Gets the [module] from the widget tree, throwing an error if not found.
  static M of<M extends Module>(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  /// Checks if the module has changed to determine if rebuild is needed.
  @override
  bool updateShouldNotify(covariant _InheritedModuleScope<M> oldWidget) =>
      oldWidget.module != module;
}

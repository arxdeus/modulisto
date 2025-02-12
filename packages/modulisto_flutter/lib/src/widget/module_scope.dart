import 'package:flutter/material.dart';
import 'package:modulisto/modulisto.dart';

/// {@template module_scope}
/// ModuleScope widget.
/// {@endtemplate}
class ModuleScope<M extends Module> extends StatefulWidget {
  /// {@macro module_scope}
  const ModuleScope({
    required this.child,
    required this.create,
    super.key,
  });

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

  final M Function(BuildContext context) create;
  final Widget child;

  /// Get the current [Module]
  static M of<M extends Module>(BuildContext context) => _InheritedModuleScope.of<M>(context, listen: false);

  @override
  State<ModuleScope<M>> createState() => _ModuleScopeState<M>();
}

/// State for widget ModuleScope.
class _ModuleScopeState<M extends Module> extends State<ModuleScope<M>> {
  late final M module = widget.create(context);

  @override
  Widget build(BuildContext context) => _InheritedModuleScope<M>(
        module: module,
        child: widget.child,
      );
}

/// Inherited widget for quick access in the element tree.
class _InheritedModuleScope<M> extends InheritedWidget {
  const _InheritedModuleScope({
    required this.module,
    required super.child,
  });

  final M module;

  static M? maybeOf<M extends Module>(BuildContext context, {bool listen = true}) => (listen
          ? context.dependOnInheritedWidgetOfExactType<_InheritedModuleScope<M>>()
          : context.getInheritedWidgetOfExactType<_InheritedModuleScope<M>>())
      ?.module;

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _InheritedModuleScope of the exact type',
        'out_of_scope',
      );

  static M of<M extends Module>(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _InheritedModuleScope<M> oldWidget) => oldWidget.module != module;
}

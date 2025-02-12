import 'package:flutter/material.dart';
import 'package:modulisto/modulisto.dart';

base class DummyModule extends Module {}

abstract final class TestUtil {
  /// Basic wrapper for the current widgets.
  static Widget appContext({required Widget child, Size? size}) => MediaQuery(
        data: MediaQueryData(size: size ?? const Size(800, 600)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: DefaultSelectionStyle(
              child: ScaffoldMessenger(
                child: HeroControllerScope.none(
                  child: Navigator(
                    pages: <Page<void>>[
                      MaterialPage<void>(
                        child: Scaffold(
                          body: SafeArea(
                            child: Center(
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onDidRemovePage: (route) => route.canPop,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

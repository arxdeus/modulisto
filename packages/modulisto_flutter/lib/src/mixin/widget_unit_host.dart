import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:modulisto/modulisto.dart';

@internal
mixin WidgetUnitHost<_W extends StatefulWidget> on State<_W> implements UnitHost {}

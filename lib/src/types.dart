import 'package:flutter/widgets.dart';

typedef StemWidgetBuilder<T> = Widget Function(
    BuildContext context, T controller);

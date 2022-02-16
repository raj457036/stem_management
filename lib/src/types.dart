import 'package:flutter/widgets.dart';

import 'stem_state.dart';
import 'stem_notifiers.dart';

typedef StemsGetter<T> = List<Stem> Function(T controller);

typedef StemGetter<T, K> = Stem<K> Function(T controller);
typedef MultiStemGetter<T> = List<Stem> Function(T controller);

typedef StemWidgetBuilder<T> = Widget Function(
    BuildContext context, T controller);

typedef StemCachedChildWidgetBuilder<T> = Widget Function(
    BuildContext context, T controller, Widget? child);

typedef StemStateBuilder<T extends StemState> = T Function();

typedef SideEffectCallback<T> = void Function(T controller);

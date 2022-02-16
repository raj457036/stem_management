import 'package:flutter/widgets.dart';

import 'stem_state.dart';

final _stateCache = <ValueKey<int>, StemState>{};

class StateHolder<T extends StemState> {
  final ValueKey<int> _identity;
  final T Function() create;
  final bool autoInflate;

  bool get _inflated => _stateCache[_identity] != null;

  StateHolder({
    required this.create,
    required this.autoInflate,
    required int identity,
  }) : _identity = ValueKey<int>(identity);

  T get state {
    if (!_inflated && autoInflate) {
      // if autoInflate is true we will inflate the stemState
      // if its not in the memory.
      inflate();
    }
    return _stateCache[_identity] as T;
  }

  /// Add stemState to cache
  inflate() {
    _stateCache[_identity] ??= create();
  }

  /// Remove stemState to cache
  deflate() {
    _stateCache.remove(_identity);
  }
}

class StemStateInjector<T extends StemState> extends InheritedWidget {
  final StateHolder<T> holder;

  /// returns If the [K] is in the memory
  ///
  /// **NOTE**
  /// This operation runs on O(n) because it checks for every
  /// available StemState in the memory.
  static bool stateExist<K extends StemState>() =>
      _stateCache.values.any((element) => element is K);

  T get state => holder.state;

  StemStateInjector({
    Key? key,
    required T Function() create,
    required Widget child,
  })  : holder = StateHolder<T>(
            identity: child.hashCode, create: create, autoInflate: true),
        super(
          key: key,
          child: child,
        );

  static K? of<K extends StemState>(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<StemStateInjector<K>>();

    if (ref != null) {
      return ref.holder.state;
    }

    throw Exception(
      "$K not found!",
    );
  }

  /// Returns the [Element] of [StemStateInjector] from the widget tree
  static _StemStateInjectorElement<K>? elementOf<K extends StemState>(
      BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StemStateInjector<K>>();

    return element as _StemStateInjectorElement<K>?;
  }

  @override
  bool updateShouldNotify(StemStateInjector<T> oldWidget) {
    final shouldNotify = oldWidget.child != child;

    if (shouldNotify) {
      // Removing the unnecessary stemState from the memory
      final _key = ValueKey(oldWidget.child.hashCode);
      _stateCache.remove(_key);
    }
    return shouldNotify;
  }

  @override
  _StemStateInjectorElement<T> createElement() {
    return _StemStateInjectorElement(this);
  }
}

class _StemStateInjectorElement<T extends StemState> extends InheritedElement {
  _StemStateInjectorElement(StemStateInjector<T> widget) : super(widget);

  @override
  StemStateInjector<T> get widget => super.widget as StemStateInjector<T>;

  @override
  void mount(Element? parent, Object? newSlot) {
    widget.state.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.state.afterBuild();
    });
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    widget.state.dispose();
    widget.holder.deflate();
    super.unmount();
  }
}

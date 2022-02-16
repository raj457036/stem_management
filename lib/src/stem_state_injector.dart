import 'package:flutter/widgets.dart';

import 'stem_state.dart';

final _stateCache = <dynamic, StemState>{};

class StateHolder<T extends StemState> {
  final ValueKey _identity;
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
      inflate();
    }
    return _stateCache[_identity] as T;
  }

  inflate() {
    _stateCache[_identity] ??= create();
  }

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
    bool lazy = true,
  })  : holder = StateHolder<T>(
            identity: child.hashCode, create: create, autoInflate: true),
        super(
          key: key,
          child: child,
        );

  /// removes State from the memory
  void _deflate() {
    holder.deflate();
  }

  /// adds State in the memory
  void _inflate() {
    holder.inflate();
  }

  static K? of<K extends StemState>(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<StemStateInjector<K>>();

    if (ref != null) {
      ref._inflate();
      return ref.holder.state;
    }

    throw Exception(
      "$K not found!",
    );
  }

  static _ControllerElement<K>? elementOf<K extends StemState>(
      BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StemStateInjector<K>>();

    (element?.widget as StemStateInjector<K>?)?._inflate();
    return element as _ControllerElement<K>?;
  }

  @override
  bool updateShouldNotify(StemStateInjector<T> oldWidget) {
    return oldWidget.child != child;
  }

  @override
  _ControllerElement<T> createElement() {
    return _ControllerElement(this);
  }
}

class _ControllerElement<T extends StemState> extends InheritedElement {
  _ControllerElement(StemStateInjector<T> widget) : super(widget);

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
    widget._deflate();
    super.unmount();
  }
}

import 'package:flutter/widgets.dart';

import 'stem_state.dart';

typedef CreateStemState<T extends StemState> = T Function();

class _StateDelegate<T extends StemState> {
  final CreateStemState<T> create;
  late _StemStateInjectorElement owner;

  _StateDelegate({
    required this.create,
  });
}

class StateInjector<T extends StemState> extends InheritedWidget {
  final _StateDelegate<T> holder;

  /// returns If the [K] is in the memory
  ///
  /// **NOTE**
  /// This operation runs on O(n) because it checks for every
  /// available StemState in the memory.
  static bool stateExist<K extends StemState>() => true;

  StateInjector({
    Key? key,
    required CreateStemState<T> create,
    required Widget child,
  })  : holder = _StateDelegate<T>(
          create: create,
        ),
        super(
          key: key,
          child: child,
        );

  static K of<K extends StemState>(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<StateInjector<K>>();

    if (ref != null) {
      return ref.holder.owner._state as K;
    }

    throw FlutterError(
      '''
        StateInjector.of() called with a context that does not contain a $K.
        No ancestor could be found starting from the context that was passed to StateInjector.of<$K>().
        This can happen if the context you used comes from a widget above the StateInjector.
        The context used was: $context
      ''',
    );
  }

  /// Returns the [Element] of [StateInjector] from the widget tree
  static _StemStateInjectorElement<K>? elementOf<K extends StemState>(
      BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StateInjector<K>>();

    return element as _StemStateInjectorElement<K>?;
  }

  @override
  bool updateShouldNotify(StateInjector<T> oldWidget) {
    final shouldNotify = oldWidget.child != child;
    return shouldNotify;
  }

  @override
  _StemStateInjectorElement<T> createElement() {
    return _StemStateInjectorElement(this);
  }
}

class _StemStateInjectorElement<T extends StemState> extends InheritedElement {
  late T _state;

  T get state => _state;

  _StemStateInjectorElement(StateInjector<T> widget) : super(widget);

  @override
  StateInjector<T> get widget => super.widget as StateInjector<T>;

  @override
  Widget build() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _state.afterBuild();
    });
    return super.build();
  }

  @override
  void rebuild() {
    widget.holder.owner = this;
    super.rebuild();
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    widget.holder.owner = this;
    _state = widget.holder.create();
    _state.initState();

    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    _state.dispose();
    super.unmount();
  }
}

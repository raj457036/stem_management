import 'package:flutter/widgets.dart';

import 'stem_state.dart';

class StemStateInjector<T extends StemState> extends InheritedWidget {
  static final _weekMap = Expando<StemState>('STEM_STATE_WEEK_MAP');

  static bool stateExist<K>(Key key) => _weekMap[key] is K;

  final T Function() create;
  T? get state => _weekMap[key!] as T?;

  StemStateInjector({
    Key? key,
    required this.create,
    required Widget child,
  }) : super(key: key ?? ValueKey("$T"), child: child) {
    inflate();
  }

  void deflate() {
    _weekMap[key!] = null;
  }

  void inflate() {
    if (_weekMap[key!] == null) {
      _weekMap[key!] = create();
    }
  }

  static K? of<K extends StemState>(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<StemStateInjector<K>>();

    if (ref != null) {
      ref.inflate();
      return ref.state;
    }

    throw Exception(
      "$K not found!",
    );
  }

  static _ControllerElement<K>? elementOf<K extends StemState>(
      BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StemStateInjector<K>>();

    (element?.widget as StemStateInjector<K>).inflate();
    return element as _ControllerElement<K>?;
  }

  @override
  bool updateShouldNotify(StemStateInjector<T> oldWidget) {
    if (oldWidget.key != key) _weekMap[oldWidget.key!] = null;
    return oldWidget.state != state;
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
    super.mount(parent, newSlot);

    widget.state?.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.state?.afterBuild();
    });
  }

  @override
  void unmount() {
    widget.state?.dispose();
    widget.deflate();
    super.unmount();
  }
}

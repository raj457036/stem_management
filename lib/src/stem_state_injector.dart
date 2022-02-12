import 'package:flutter/widgets.dart';

import 'stem.dart';

final _stemStates = <Object, StemState>{};

class StemStateInjector<T extends StemState> extends InheritedWidget {
  final T Function() create;
  T? get stem => _stemStates[key] as T?;

  StemStateInjector({
    Key? key,
    required this.create,
    required Widget child,
  }) : super(key: key ?? ValueKey("$T"), child: child) {
    inflate();
  }

  void deflate() {
    _stemStates.remove(key);
  }

  void inflate() {
    if (_stemStates[key] == null) {
      _stemStates[key!] = create();
    }
  }

  static K? of<K extends StemState>(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<StemStateInjector<K>>();

    if (ref != null) {
      ref.inflate();
      return ref.stem;
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
    if (oldWidget.key != key) _stemStates.remove(oldWidget.key);
    return oldWidget.stem != stem;
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

    widget.stem?.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.stem?.afterBuild();
    });
  }

  @override
  void unmount() {
    widget.stem?.dispose();
    widget.deflate();
    super.unmount();
  }
}

import 'package:flutter/widgets.dart';

import 'stem.dart';

class StemInjector<T extends Stem> extends InheritedWidget {
  final T controller;

  const StemInjector({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static K? of<K extends Stem>(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<StemInjector<K>>();

    if (ref != null) {
      return ref.controller;
    }

    throw Exception(
      "$K not found!",
    );
  }

  static _ControllerElement<K>? elementOf<K extends Stem>(
      BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StemInjector<K>>();

    return element as _ControllerElement<K>?;
  }

  @override
  bool updateShouldNotify(StemInjector<T> oldWidget) {
    return oldWidget.controller != controller;
  }

  @override
  _ControllerElement<T> createElement() {
    return _ControllerElement(this);
  }
}

class _ControllerElement<T extends Stem> extends InheritedElement {
  _ControllerElement(StemInjector<T> widget) : super(widget);

  @override
  StemInjector<T> get widget => super.widget as StemInjector<T>;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    widget.controller.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.controller.afterBuild();
    });
  }

  @override
  void unmount() {
    widget.controller.dispose();
    super.unmount();
  }
}

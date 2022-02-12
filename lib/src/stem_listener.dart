import 'package:flutter/widgets.dart';

import 'stem.dart';
import 'stem_notifiers.dart';
import 'stem_state_injector.dart';
import 'types.dart';

class StemListener<T extends StemState, K> extends StatefulWidget {
  final Widget child;
  final StemGetter<T, K> listenTo;
  final SideEffectCallback<K> onListen;

  const StemListener({
    Key? key,
    required this.listenTo,
    required this.child,
    required this.onListen,
  }) : super(key: key);

  @override
  State<StemListener<T, K>> createState() => _StemListenerState<T, K>();
}

class _StemListenerState<T extends StemState, K>
    extends State<StemListener<T, K>> {
  T? _controller;
  Stem<K>? _stem;

  @override
  void initState() {
    super.initState();
    _controller = StemStateInjector.elementOf<T>(context)?.widget.stem;
    setListeners();
  }

  void _listenerValueChanged() => widget.onListen(_stem!.value!);

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return ErrorWidget("$T not found.");
    }

    return widget.child;
  }

  void setListeners() {
    if (_controller != null) {
      _stem = widget.listenTo(_controller!);
      _stem?.addListener(_listenerValueChanged);
    }
  }

  void unsetListeners() {
    if (_controller != null) {
      _stem?.removeListener(_listenerValueChanged);
    }
  }

  @override
  void dispose() {
    unsetListeners();
    super.dispose();
  }
}

import 'package:flutter/widgets.dart';

import 'stem_state_injector.dart';
import 'stem_state.dart';
import 'types.dart';

class StemBuilder<T extends StemState> extends StatefulWidget {
  final StemsGetter<T> listenTo;
  final StemCachedChildWidgetBuilder<T> builder;
  final Widget? child;

  const StemBuilder({
    Key? key,
    required this.listenTo,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  _StemBuilderState createState() => _StemBuilderState<T>();
}

class _StemBuilderState<T extends StemState> extends State<StemBuilder<T>> {
  T? _controller;

  @override
  void initState() {
    super.initState();
    _controller = StemStateInjector.elementOf<T>(context)?.widget.state;
    setListeners();
  }

  void _listenerValueChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    try {
      final T? _controller = StemStateInjector.of(context);
      return widget.builder(context, _controller!, widget.child);
    } catch (e) {
      return ErrorWidget(e);
    }
  }

  void setListeners() {
    if (_controller != null) {
      final listeners = widget.listenTo(_controller!);

      for (var listener in listeners) {
        listener.addListener(_listenerValueChanged);
      }
    }
  }

  void unsetListeners() {
    if (_controller != null) {
      final listeners = widget.listenTo(_controller!);
      for (var listener in listeners) {
        listener.removeListener(_listenerValueChanged);
      }
    }
  }

  @override
  void dispose() {
    unsetListeners();
    super.dispose();
  }
}

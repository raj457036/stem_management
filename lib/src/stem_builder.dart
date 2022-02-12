import 'package:flutter/widgets.dart';

import 'stem_injector.dart';
import 'stem.dart';
import 'types.dart';

typedef ListenerSubscriber<T> = List<ChangeNotifier> Function(T controller);

class StemBuilder<T extends Stem> extends StatefulWidget {
  final ListenerSubscriber<T> listen;
  final StemWidgetBuilder<T> builder;

  const StemBuilder({
    Key? key,
    required this.listen,
    required this.builder,
  }) : super(key: key);

  @override
  _StemBuilderState createState() => _StemBuilderState<T>();
}

class _StemBuilderState<T extends Stem> extends State<StemBuilder<T>> {
  T? _controller;

  @override
  void initState() {
    super.initState();
    _controller = StemInjector.elementOf<T>(context)?.widget.controller;

    if (_controller != null) {
      final listeners = widget.listen(_controller!);
      for (var listener in listeners) {
        listener.addListener(_update);
      }
    }
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    try {
      final T? _controller = StemInjector.of(context);
      return widget.builder(context, _controller!);
    } catch (e) {
      return ErrorWidget(e);
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      final listeners = widget.listen(_controller!);

      for (var listener in listeners) {
        listener.removeListener(_update);
      }
    }

    super.dispose();
  }
}

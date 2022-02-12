import 'package:flutter/widgets.dart';

import 'stem.dart';
import 'stem_injector.dart';
import 'types.dart';

class StemProvider<T extends Stem> extends StatelessWidget {
  final StemWidgetBuilder<T> injector;

  const StemProvider({
    Key? key,
    required this.injector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final T? _controller = StemInjector.of(context);
      return injector(context, _controller!);
    } catch (e) {
      return ErrorWidget(e);
    }
  }
}

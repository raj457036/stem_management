import 'package:flutter/widgets.dart';

import 'stem.dart';
import 'stem_state_injector.dart';
import 'types.dart';

class StemAccessor<T extends StemState> extends StatelessWidget {
  final StemWidgetBuilder<T> builder;

  const StemAccessor({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final T? _controller = StemStateInjector.of(context);
      return builder(context, _controller!);
    } catch (e) {
      return ErrorWidget(e);
    }
  }
}

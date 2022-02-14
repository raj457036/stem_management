import 'package:flutter/widgets.dart';
import 'package:stem/stem.dart';

class StemSubscriber<L extends StemState, A extends StemState, T>
    extends StatelessWidget {
  final Stem<T> Function(L) listenTo;
  final Widget child;
  final void Function(L, A) onListen;
  const StemSubscriber({
    Key? key,
    required this.listenTo,
    required this.child,
    required this.onListen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StemAccessor<A>(
      builder: (context, accessor) => StemListener<L, T>(
        listenTo: listenTo,
        child: child,
        onListen: (listenable) => onListen(listenable, accessor),
      ),
    );
  }
}

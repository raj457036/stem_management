import 'package:stem/stem.dart';

class CounterState extends StemState {
  final counter = Stem('counter', Memoize(0, size: 1000));

  void increment() {
    counter().value++;
    counter.forceUpdate();
  }

  void decrement() {
    counter().value--;
    counter.forceUpdate();
  }

  void undo() {
    counter().undo();
    counter.forceUpdate();
  }

  void redo() {
    counter().redo();
    counter.forceUpdate();
  }

  @override
  List<Stem> get props => [counter];
}

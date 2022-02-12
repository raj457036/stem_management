import 'package:stem/stem.dart';

class CounterState extends StemState {
  final counter = Stem('counter', 0);

  void increment() => counter.value++;
  void decrement() => counter.value--;

  @override
  List<Stem> get props => [counter];
}

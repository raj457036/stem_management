import 'package:stem/stem.dart';

class CounterState extends StemState {
  final counter = Stem('counter', 0);
  final x = List.generate(10000, (_) => _);

  void increment() => counter.value++;
  void decrement() => counter.value--;

  @override
  List<Stem> get props => [counter];
}

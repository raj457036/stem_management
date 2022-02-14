import 'package:stem/stem.dart';

class AsyncCounterState extends StemState {
  final counter = TripleStem('counter', 0);

  Future<void> increment() async {
    counter.setLoading();
    await Future.delayed(const Duration(milliseconds: 500));

    if (counter.data == 4) {
      counter.setError("Error Occured");
    } else {
      counter.setData(counter.data + 1);
    }
  }

  Future<void> decrement() async {
    counter.setLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    counter.setData(counter.data - 1);
  }

  @override
  List<Stem> get props => [counter];
}

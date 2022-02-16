import 'package:flutter_test/flutter_test.dart';
import 'package:stem/stem.dart';

class TestStemState1 extends StemState {
  final count = Stem("count", 0);

  increment() => count.value++;

  @override
  List<Stem> get props => [];
}

class TestStemState2 extends StemState {
  final count = Stem("count", 0);
  final debounceCount = DebouncedStem("debounceCount", 0);
  final currentCountState = TripleStem<int?>("currentCount", null);

  increment() => count.value++;
  incrementDebounce() => debounceCount.value++;

  @override
  List<Stem> get props => [count, debounceCount, currentCountState];
}

void main() {
  group("Stem Tests : ", () {
    late TestStemState1 stemState1;
    late TestStemState2 stemState2;

    setUp(() {
      stemState1 = TestStemState1();
      stemState2 = TestStemState2();
    });

    group("calling increment will ", () {
      test("cause exception on stemState1 as count is not in props.", () {
        try {
          stemState1.increment();
        } catch (e) {
          expect(e, const TypeMatcher<Exception>());
        }
      });

      test("not cause exception on stemState2 as count is in props.", () {
        stemState2.increment();

        expect(stemState2.count.value, 1);
      });
    });

    group("Debounced Stem Tests", () {
      test("frequent changes should get discarded.", () async {
        expect(stemState2.debounceCount.value, 0);

        stemState2
          ..incrementDebounce()
          ..incrementDebounce()
          ..incrementDebounce()
          ..incrementDebounce();

        /// settling down
        await Future.delayed(const Duration(seconds: 1));

        /// even though we call the increase debounce 4 times continuously
        /// the value should be 1.
        expect(stemState2.debounceCount.value, 1);
      });
    });

    group("Triple Stem Tests", () {
      test("If initial value is null the default state will be loading", () {
        expect(stemState2.currentCountState.value, UnionStateType.loading);
        expect(stemState2.currentCountState.isLoading, true);
      });

      test("on setData the state will be data", () {
        stemState2.currentCountState.setData(1);
        expect(stemState2.currentCountState.value, UnionStateType.data);
        expect(stemState2.currentCountState.data, 1);
      });

      test("on setError the state will be error", () {
        stemState2.currentCountState.setError(Exception("Some Exception"));
        expect(stemState2.currentCountState.value, UnionStateType.error);
        expect(
            stemState2.currentCountState.error, const TypeMatcher<Exception>());
      });
    });
  });
}

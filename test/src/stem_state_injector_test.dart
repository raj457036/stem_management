import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stem/stem.dart';

import '../utils/root_widget.dart';

class TestStemState extends StemState {
  @override
  List<Stem> get props => [];
}

class TestStemStateWidget extends StatelessWidget {
  final TestStemState state;
  const TestStemStateWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Root(
      child: StemStateInjector(
        key: const ValueKey("test"),
        create: () => state,
        child: const Center(
          child: Text("Hello World"),
        ),
      ),
    );
  }
}

void main() {
  group(
    "Stem State Injector: ",
    () {
      late TestStemState stemState;

      setUp(() {
        stemState = TestStemState();
      });

      testWidgets(
        "state must be in memory",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestStemStateWidget(state: stemState),
          );

          final stateInMemory = StemStateInjector.stateExist<TestStemState>(
            const ValueKey('test'),
          );

          expect(stateInMemory, true);
        },
      );

      testWidgets(
        "state must be removed from memory once widget is not part of the tree.",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestStemStateWidget(state: stemState),
          );

          bool stateInMemory = StemStateInjector.stateExist<TestStemState>(
            const ValueKey('test'),
          );

          expect(stateInMemory, true);

          // Removing the TestStemStateWidget from the widget tree by replacing
          // with Center widget
          await tester.pumpWidget(const Center());

          stateInMemory = StemStateInjector.stateExist<TestStemState>(
            const ValueKey('test'),
          );

          expect(stateInMemory, false);
        },
      );
    },
  );
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stem/stem.dart';

import '../utils/root_widget.dart';

class TestStemState extends StemState {
  int sequence = 0;

  @override
  void initState() {
    sequence++;
    super.initState();
  }

  @override
  void afterBuild() {
    sequence++;
    super.afterBuild();
  }

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
      child: StateInjector(
        create: () => state,
        child: const Center(
          child: Text("Hello World"),
        ),
      ),
    );
  }
}

void main() {
  group("Stem State Test: ", () {
    late TestStemState stemState;

    setUp(() {
      stemState = TestStemState();
    });

    testWidgets(
      "mounted must be false when widget is not part of the tree",
      (WidgetTester tester) async {
        expect(stemState.mounted, false);
      },
    );

    testWidgets(
      "initState must get called and mark mounted true when widget become part of the tree",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TestStemStateWidget(state: stemState),
        );

        expect(stemState.mounted, true);
      },
    );

    testWidgets(
      "afterBuild must be called just after initState",
      (WidgetTester tester) async {
        expect(stemState.sequence, 0);

        await tester.pumpWidget(
          TestStemStateWidget(state: stemState),
        );

        /// the sequence value must be 2 because sequence was first incremented
        /// initState
        expect(stemState.sequence, 2);
      },
    );

    testWidgets(
      "dispose must be called when widget is removed from the tree and mark mounted false",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TestStemStateWidget(state: stemState),
        );

        expect(stemState.mounted, true);

        // Removing the TestStemStateWidget from the widget tree by replacing
        // with Center widget
        await tester.pumpWidget(const Center());

        expect(stemState.mounted, false);
      },
    );
  });
}

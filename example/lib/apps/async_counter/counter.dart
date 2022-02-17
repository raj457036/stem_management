import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

import 'controller.dart';

class AsyncCounterApp extends StatelessWidget {
  const AsyncCounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateInjector(
      key: const ValueKey('async-counter'),
      create: () => AsyncCounterState(),
      child: const CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
      ),
      body: Center(
        child: StemBuilder<AsyncCounterState>(
          listenTo: (controller) => [controller.counter],
          builder: (context, controller, child) => controller.counter.on(
            error: (error) => ErrorWidget(error),
            data: (count) => Text("You Tapped $count times."),
            loading: (last) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Last Data $last"),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: StemAccessor<AsyncCounterState>(
        builder: (context, controller) => ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "i",
              tooltip: controller.toString(),
              onPressed: controller.increment,
              child: const Icon(Icons.arrow_upward_sharp),
            ),
            FloatingActionButton(
              heroTag: "d",
              tooltip: controller.toString(),
              onPressed: controller.decrement,
              child: const Icon(Icons.arrow_downward_sharp),
            ),
          ],
        ),
      ),
    );
  }
}

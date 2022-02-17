import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

import 'controller.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateInjector(
      create: () => CounterState(),
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
        child: StemBuilder<CounterState>(
          listenTo: (controller) => [controller.counter],
          builder: (context, controller, child) {
            return Text("Counter : ${controller.counter().value}");
          },
        ),
      ),
      floatingActionButton: StemAccessor<CounterState>(
        builder: (context, controller) => ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "i",
              tooltip: "Increment",
              onPressed: controller.increment,
              child: const Icon(Icons.arrow_upward_sharp),
            ),
            FloatingActionButton(
              heroTag: "d",
              tooltip: "Decrement",
              onPressed: controller.decrement,
              child: const Icon(Icons.arrow_downward_sharp),
            ),
            FloatingActionButton(
              heroTag: "undo",
              tooltip: "Undo",
              onPressed: controller.undo,
              child: const Icon(Icons.undo),
            ),
            FloatingActionButton(
              heroTag: "redo",
              tooltip: "Redo",
              onPressed: controller.redo,
              child: const Icon(Icons.redo),
            ),
          ],
        ),
      ),
    );
  }
}

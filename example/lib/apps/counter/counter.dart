import 'package:example/apps/counter/controller.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StemStateInjector(
      create: () => CounterState(),
      child: const CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StemListener<CounterState, int>(
      listenTo: (controller) => controller.counter,
      onListen: (value) {
        print("counter value changed");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter App"),
        ),
        body: Center(
          child: StemBuilder<CounterState>(
            listenTo: (controller) => [controller.counter],
            builder: (context, controller, child) =>
                Text("Counter : $controller ${controller.counter}"),
          ),
        ),
        floatingActionButton: StemAccessor<CounterState>(
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
      ),
    );
  }
}

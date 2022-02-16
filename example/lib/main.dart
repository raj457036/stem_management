import 'dart:developer';

import 'package:example/apps/counter/counter.dart';
import 'package:example/apps/todo/todo.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

import 'apps/async_counter/counter.dart';

class CustomStemEventObserver extends StemChangeObserver {
  @override
  void onStemChange(StemState state, String name, oldValue, newValue) {
    super.onStemChange(state, name, oldValue, newValue);
    log("Transition (${state.runtimeType}: $name): Current $oldValue"
        " -> Next State $newValue");
  }

  @override
  void onCreateStemState(StemState state) {
    super.onCreateStemState(state);
    log("Created: $state : ${state.hashCode}");
  }

  @override
  void onDisposeStemState(StemState state) {
    super.onDisposeStemState(state);
    log("Deleted: $state : ${state.hashCode}");
  }

  @override
  void onCustomStemEvent(StemState state, Object value) {
    super.onCustomStemEvent(state, value);

    log("Custom Event (${state.runtimeType}: $value");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StemConfig.instance.observer = CustomStemEventObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stem State Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Stem State Management Examples'),
      routes: {
        "/counter": (context) => const CounterApp(),
        "/todo": (context) => const TodoApp(),
        "/asyncCounter": (context) => const AsyncCounterApp(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Counter App"),
            onTap: () => Navigator.pushNamed(context, '/counter'),
          ),
          ListTile(
            title: const Text("Todo App"),
            onTap: () => Navigator.pushNamed(context, '/todo'),
          ),
          ListTile(
            title: const Text("Async Counter App"),
            onTap: () => Navigator.pushNamed(context, "/asyncCounter"),
          ),
        ],
      ),
    );
  }
}

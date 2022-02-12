import 'dart:developer';

import 'package:example/apps/counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

class Observer extends StemChangeObserver {
  @override
  void onStemChange(StemState state, oldValue, Stem newValue) {
    super.onStemChange(state, oldValue, newValue);
    log("Transition (${state.runtimeType}: ${newValue.name}): Current $oldValue"
        " -> Next State ${newValue.value}");
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
}

void main() {
  StemConfig.instance.observer = Observer();

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
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Counter App"),
            onTap: () => Navigator.pushNamed(context, '/counter'),
          )
        ],
      ),
    );
  }
}

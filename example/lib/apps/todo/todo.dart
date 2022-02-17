import 'package:example/apps/todo/screens/list/list.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

import 'controllers/todo_controller.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateInjector(
      create: () => TodoStateController(),
      child: const TodoList(),
    );
  }
}

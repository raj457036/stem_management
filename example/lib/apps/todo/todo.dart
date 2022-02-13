import 'package:example/apps/todo/global/todo_controller.dart';
import 'package:example/apps/todo/screens/list/list.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StemStateInjector(
      key: const ValueKey("todolist"),
      create: () => TodoStateController(),
      child: const TodoList(),
    );
  }
}

import 'package:example/apps/todo/global/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:stem/stem.dart';

import 'todo_bottom_sheet.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: StemBuilder<TodoStateController>(
        builder: (context, controller, child) {
          final todos = controller.todos();

          if (todos.isEmpty) {
            return const Center(
              child: Text("No Todo Yet"),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Dismissible(
                key: ValueKey("TODO-${todo.id}"),
                onDismissed: (_) {
                  controller.deleteTodo(index);
                },
                child: ListTile(
                  leading: Text("${todo.id + 1}"),
                  title: Text(todo.content),
                  trailing: Icon(
                    todo.pinned ? Icons.star : Icons.star_border,
                  ),
                ),
              );
            },
          );
        },
        listenTo: (controller) => [controller.todos],
      ),
      floatingActionButton: StemAccessor<TodoStateController>(
        builder: (context, controller) => FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final content = await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const TodoBottomSheet(),
            );

            if (content != null) {
              controller.createTodo(content);
            }
          },
        ),
      ),
    );
  }
}

import 'package:stem/stem.dart';

import '../models/todo.dart';

class TodoStateController extends StemState {
  final nextId = Stem('lastId', 0, registerEvent: false);
  final todos = Stem('todos', <Todo>[]);

  void createTodo(String content) {
    trigger(this, 'createTodo Called');
    final todo = Todo(
      id: nextId.value,
      content: content,
      pinned: false,
    );

    todos.value = [...todos(), todo];
    nextId.value++;
  }

  void deleteTodo(int index) {
    trigger(this, 'deleteTodo Called');
    final _temp = [...todos()]..removeAt(index);
    todos.value = _temp;
  }

  @override
  List<Stem> get props => [todos];
}

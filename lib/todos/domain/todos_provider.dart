import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';

final todosProvider = StateNotifierProvider<TodosNotifier, List<ToDo>>((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<ToDo>> {
  TodosNotifier() : super([]);

  addTodo() {
    state = [...state, ToDo.empty()];
  }

  updateTodo({required ToDo item}) {
    final index = state.indexWhere((e) => e.id == item.id);
    state.removeAt(index);
    state.insert(index, item);
    state = [...state];
  }
}

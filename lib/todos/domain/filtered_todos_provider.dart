import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

final filteredTodosProvider = Provider<List<ToDo>>((ref) {
  final allTodos = ref.watch(todosProvider);
  final filter = ref.watch(todosFilter);
  return allTodos.where((todo) => todo.title.contains(filter)).toList();
});

final todosFilter = StateProvider<String>((ref) => '');

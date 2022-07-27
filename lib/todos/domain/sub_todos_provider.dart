import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final subTodosProvider =
    StateProvider.family<List<ToDo>, UniqueId>((ref, UniqueId parentId) {
  final allTodos = ref.watch(todosProvider);
  final subTodos =
      allTodos.where((element) => element.parentId == parentId).toList();
  return subTodos;
});

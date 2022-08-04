import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final filteredTodosProvider = Provider<List<ToDo>>((ref) {
  final allTodos = ref.watch(todosProvider);
  final filter = ref.watch(todosFilter);
  final filterByTags = ref.watch(todosFilterByTags);
  final filterByDate = ref.watch(todosFilterByDate);
  List<ToDo> filteredTodos = allTodos;
  if (filterByDate != null) {
    filteredTodos =
        filteredTodos.where((todo) => todo.date == filterByDate).toList();
  }
  if (filterByTags.isNotEmpty) {
    filteredTodos = filteredTodos.where((todo) {
      return filterByTags.every((element) => todo.tags.contains(element));
    }).toList();
  }
  return filteredTodos.where((todo) => todo.title.contains(filter)).toList();
});

final todosFilter = StateProvider<String>((ref) => '');
final todosFilterByTags =
    StateNotifierProvider<TodosFilterByTagsNotifier, List<UniqueId>>(
        (ref) => TodosFilterByTagsNotifier());
final todosFilterByDate = StateProvider<DateTime?>((ref) => null);

class TodosFilterByTagsNotifier extends StateNotifier<List<UniqueId>> {
  TodosFilterByTagsNotifier() : super([]);
  addFilter(UniqueId id) => state = [...state, id];
  removeFilter(UniqueId id) =>
      state = [...state.where((element) => element != id)];
  toggleFilter(UniqueId id) {
    if (state.contains(id)) {
      removeFilter(id);
    } else {
      addFilter(id);
    }
  }

  List<UniqueId> getFilters() => state;
}

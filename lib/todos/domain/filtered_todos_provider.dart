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
  if (ref.watch(todosFilterShowUnDone)) {
    filteredTodos =
        filteredTodos.where((element) => element.done == false).toList();
  }
  if (!ref.watch(todosFilterShowAll)) {
    filteredTodos =
        filteredTodos.where((element) => element.parentId == null).toList();
  }
  if (filterByDate != null) {
    filteredTodos =
        filteredTodos.where((todo) => todo.date == filterByDate).toList();
  }
  if (filterByTags.isNotEmpty) {
    filteredTodos = filteredTodos.where((todo) {
      return filterByTags.every((element) => todo.tags.contains(element));
    }).toList();
  }
  filteredTodos =
      filteredTodos.where((todo) => todo.title.contains(filter)).toList();
  List<ToDo> withDates = [];
  List<ToDo> withNoDates = [];
  for (final item in filteredTodos) {
    if (item.date != null) {
      if (!ref.watch(todosFilterShowFutureDates)) {
        if (item.date!.millisecondsSinceEpoch <=
            DateTime.now().millisecondsSinceEpoch) {
          withDates.add(item);
        }
      } else {
        withDates.add(item);
      }
    } else {
      withNoDates.add(item);
    }
  }

  withDates.sort((a, b) {
    return b.date!.compareTo(a.date!);
  });
  return [...withDates, ...withNoDates];
});

final todosFilter = StateProvider<String>((ref) => '');
final todosFilterByTags =
    StateNotifierProvider<TodosFilterByTagsNotifier, List<UniqueId>>(
        (ref) => TodosFilterByTagsNotifier());
final todosFilterByDate = StateProvider<DateTime?>((ref) => null);
final todosFilterShowAll = StateProvider<bool>((ref) => false);
final todosFilterShowUnDone = StateProvider<bool>((ref) => true);
final todosFilterShowFutureDates = StateProvider<bool>((ref) => false);

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

  clearFilter() => state = [];
  List<UniqueId> getFilters() => state;
}

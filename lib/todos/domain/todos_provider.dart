import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final todosProvider = StateNotifierProvider<TodosNotifier, List<ToDo>>((ref) {
  final notifier = TodosNotifier(ref);
  ref.watch(todosDbProvider).whenData(
        (value) => notifier.setDb(value),
      );
  notifier.getTodos();
  return notifier;
});

class TodosNotifier extends StateNotifier<List<ToDo>> {
  StateNotifierProviderRef<TodosNotifier, List<ToDo>> ref;
  TodosNotifier(this.ref) : super([]);
  IDbService? db;

  setDb(IDbService instance) {
    db = instance;
  }

  getTodos() async {
    final data = db?.getAll();
    if (data != null) {
      await for (final map in data) {
        state = [...state, ToDo.fromMap(map)];
      }
    }
  }

  addTodo({ToDo? todo}) {
    final newItem = todo ?? ToDo.empty();
    state = [...state, newItem];
  }

  addSubTodo(UniqueId parent) {
    state = [...state, ToDo.empty().copyWith(parentId: parent)];
  }

  updateTodo({required ToDo item}) {
    db?.update(id: item.id.toString(), item: item.toMap());
    final index = state.indexWhere((e) => e.id == item.id);
    state.removeAt(index);
    state.insert(index, item);
    state = [...state];
  }

  checkAndCleanTodos() {
    List<ToDo> cleanTodos = [];
    for (final todo in state) {
      final existingTags = todo.tags
          .where((id) => ref.watch(tagsProvider.notifier).isTagIdExists(id))
          .toList();
      final updatedTag = todo.copyWith(tags: existingTags);
      cleanTodos.add(updatedTag);
      if (updatedTag != todo) {
        updateTodo(item: updatedTag);
      }
    }
    state = cleanTodos;
  }
}

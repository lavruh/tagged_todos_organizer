import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final todosProvider = StateNotifierProvider<TodosNotifier, List<ToDo>>((ref) {
  final notifier = TodosNotifier();
  ref.watch(todosDbProvider).whenData(
        (value) => notifier.setDb(value),
      );
  notifier.getTodos(ref);
  return notifier;
});

class TodosNotifier extends StateNotifier<List<ToDo>> {
  TodosNotifier() : super([]);
  IDbService? db;

  setDb(IDbService instance) {
    db = instance;
  }

  getTodos(StateNotifierProviderRef<TodosNotifier, List<ToDo>> ref) async {
    final data = db?.getAll();
    if (data != null) {
      await for (final map in data) {
        ToDo todo = ToDo.fromMap(map);
        final existingTags = todo.tags
            .where((id) => ref.read(tagsProvider.notifier).isTagIdExists(id))
            .toList();
        state = [...state, todo.copyWith(tags: existingTags)];
        if (existingTags != todo.tags) {
          updateTodo(item: todo.copyWith(tags: existingTags));
        }
      }
    }
  }

  addTodo() {
    state = [...state, ToDo.empty()];
  }

  updateTodo({required ToDo item}) {
    db?.update(id: item.id.toString(), item: item.toMap());
    final index = state.indexWhere((e) => e.id == item.id);
    state.removeAt(index);
    state.insert(index, item);
    state = [...state];
  }
}

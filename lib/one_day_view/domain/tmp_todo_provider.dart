import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final tmpTodoProvider =
    StateNotifierProvider<TmpTodoNotifier, List<ToDo>>((ref) {
  final notifier = TmpTodoNotifier(ref);
  ref.watch(tmpTodosDbProvider).whenData(
    (value) {
      notifier.setDb(value);
      notifier.getTodos();
    },
  );
  return notifier;
});

class TmpTodoNotifier extends StateNotifier<List<ToDo>> {
  TmpTodoNotifier(this.ref) : super([]);
  final Ref ref;
  IDbService? db;
  final _table = "tmp_todos";

  setDb(IDbService instance) {
    db = instance;
  }

  addTmpTodo() {
    state = [ToDo.empty().copyWith(date: DateTime.now()), ...state];
  }

  updateTmpTodo(ToDo todo) {
    final index = state.indexWhere((element) => element.id == todo.id);
    if (index == -1) return;
    state.removeAt(index);
    state.insert(index, todo);
    state = [...state];
    db?.update(id: todo.id.id, item: todo.toMap(), table: _table);
  }

  removeTmpTodo(ToDo todo) {
    state = [...state.where((element) => element.id != todo.id)];
    db?.delete(id: todo.id.id, table: _table);
  }

  void getTodos() async {
    if (db == null) return;
    await for (final map in db!.getAll(table: _table)) {
      final todo = ToDo.fromMap(map);
      state = [...state, todo];
    }
  }
}

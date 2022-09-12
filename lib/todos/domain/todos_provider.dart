import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachements_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

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
  final String tableName = 'todos';

  setDb(IDbService instance) {
    db = instance;
  }

  getTodos({String? parentId}) async {
    final table = parentId ?? tableName;
    if (db != null) {
      final data = db!.getAll(table: table).handleError((e) {
        ref.read(snackbarProvider.notifier).show(e);
      });
      await for (final map in data) {
        final todo = ToDo.fromMap(map);
        state = [...state, todo];
        await getTodos(parentId: todo.id.id);
      }
    }
  }

  addTodo({ToDo? todo}) {
    state = [...state, todo ?? ToDo.empty()];
  }

  updateTodo({required ToDo item}) async {
    final index = state.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      state.removeAt(index);
      state.insert(index, item);
      state = [...state];
    } else {
      final id = '${item.id.id}_${item.title}'.replaceAll(RegExp('/'), '');
      item = item.copyWith(id: UniqueId(id: id));
      addTodo(todo: item);
    }
    try {
      item = _updateItemAttachements(item);
    } on Exception catch (e) {
      throw Exception(e);
    }

    ref.read(todoEditorProvider.notifier).setTodo(item);

    final String table = item.parentId?.id ?? tableName;
    await db
        ?.update(id: item.id.toString(), item: item.toMap(), table: table)
        .onError((error, stackTrace) {
      return ref.read(snackbarProvider).show("$error");
    });
  }

  deleteTodo({required ToDo todo}) async {
    final String table = todo.parentId?.id ?? tableName;
    state = [...state.where((element) => element.id != todo.id)];
    await db?.delete(id: todo.id.id, table: table);
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

  ToDo _updateItemAttachements(ToDo t) {
    final attachementsState = ref.read(attachementsProvider.notifier);
    final String attachementsPath = p.join(
        attachementsState.getParentDirPath(parentId: t.parentId?.id.toString()),
        t.id.id);
    try {
      Directory(attachementsPath).createSync();
    } on FileSystemException catch (e) {
      throw Exception(e);
    }

    final attachementsList = ref.read(attachementsProvider);
    return t.copyWith(
      attachDirPath: attachementsPath,
      attacments: attachementsList,
    );
  }
}

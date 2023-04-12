import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/archive/domain/archive_provider.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
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
  TodosNotifier(this.ref) : super([]) {
    log = ref.read(logProvider.notifier);
  }
  IDbService? db;
  final String tableName = 'todos';
  late LogNotifier log;

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

  Future<ToDo> updateTodo({required ToDo item}) async {
    final index = state.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      item = item.copyWith(children: _getChildrenList(item.id));
      await _updateState(
        index,
        item,
      );
    } else {
      item = await _saveNewTodoToState(item);
    }

    try {
      if (item.parentId != null) {
        updateTodoChildren(id: item.parentId!);
      }
      item = _updateItemAttachments(item);
    } on Exception catch (e) {
      throw Exception(e);
    }

    await _updateDb(item);
    return item;
  }

  Future<void> _updateDb(ToDo item) async {
    final String table = item.parentId?.id ?? tableName;
    await db
        ?.update(id: item.id.toString(), item: item.toMap(), table: table)
        .onError((error, stackTrace) {
      return ref.read(snackbarProvider).show("$error");
    });
  }

  Future<ToDo> _saveNewTodoToState(ToDo item) async {
    final id = '${item.id.id}_${item.title}'.replaceAll(RegExp('/'), '');
    item = item.copyWith(id: UniqueId(id: id));
    addTodo(todo: item);
    await log.logTodoCreated(todo: item);
    return item;
  }

  Future<void> _updateState(int index, ToDo item) async {
    final oldTodo = state.removeAt(index);
    state.insert(index, item);
    state = [...state];
    if (oldTodo.done != item.done) {
      await log.logTodoDoneUndone(todo: item, done: item.done);
    }
  }

  deleteTodo({required ToDo todo}) async {
    final String table = todo.parentId?.id ?? tableName;
    state = [...state.where((element) => element.id != todo.id)];
    await db?.delete(id: todo.id.id, table: table);
    await ref.read(logProvider.notifier).logTodoDeleted(todo: todo);
  }

  setTodoDoneUndone({required bool value, required ToDo todo}) {
    final newItem = todo.copyWith(done: value);
    updateTodo(item: newItem);
    if (todo.parentId != null) {
      ref.read(subTodosProvider(todo.parentId!));
    }
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

  ToDo _updateItemAttachments(ToDo t) {
    final attachmentsState = ref.read(attachmentsProvider.notifier);
    final String attachmentsPath = p.join(
        attachmentsState.getParentDirPath(parentId: t.parentId?.id.toString()),
        t.id.id);
    return t.copyWith(
      attachDirPath: attachmentsPath,
    );
  }

  Future<bool> archiveTodo({required ToDo todo}) async {
    final archive = ref.read(archiveProvider);
    try {
      await archive.add(todo);
      await deleteTodo(todo: todo);
      await ref.read(logProvider.notifier).logTodoArchived(todo: todo);
      return true;
    } catch (e) {
      ref.read(snackbarProvider).show(e.toString());
    }
    return false;
  }

  updateTodoChildren({required UniqueId id}) {
    final item = state.firstWhere((element) => element.id == id);
    updateTodo(item: item.copyWith(children: _getChildrenList(id)));
  }

  List<UniqueId> _getChildrenList(UniqueId id) {
    List<UniqueId> childrenList = [];
    for (final i in state) {
      if (i.parentId == id) childrenList.add(i.id);
    }
    return childrenList;
  }

  bool hasChild({required UniqueId node, required UniqueId child}) {
    final children = state.where((e) => e.parentId == node);
    if (children.isNotEmpty) {
      for (ToDo c in children) {
        if (c.id == child) {
          return true;
        } else {
          return hasChild(node: c.id, child: child);
        }
      }
    }
    return false;
  }
}

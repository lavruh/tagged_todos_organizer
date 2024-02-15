import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/archive/domain/archive_provider.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
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

  Future<ToDo> updateTodo({required ToDo item, editId = false}) async {
    final index = state.indexWhere((e) => e.id == item.id);

    final originalId = item.id;
    if (editId) {
      final newId = UniqueId.generateWithSuffix(item.title);
      item = item.copyWith(id: newId);
    }

    try {
      if (item.parentId != null) {
        updateTodoChildren(id: item.parentId!);
      }
      item = _updateItemAttachmentsPath(item);
    } on Exception catch (e) {
      throw Exception(e);
    }

    if (index != -1) {
      item = item.copyWith(children: _getChildrenList(item.id));
      await _updateState(index, item);
    } else {
      item = await _saveNewTodoToState(item);
    }

    final dbItemId = index == -1 ? item.id : originalId;

    await _updateDb(item: item, id: dbItemId);
    return item;
  }

  Future<void> _updateDb({required ToDo item, required UniqueId id}) async {
    final String table = item.parentId?.id ?? tableName;
    await db
        ?.update(id: id.toString(), item: item.toMap(), table: table)
        .onError((error, stackTrace) {
      return ref.read(snackbarProvider).show("$error");
    });
  }

  Future<ToDo> _saveNewTodoToState(ToDo item) async {
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

  ToDo _updateItemAttachmentsPath(ToDo t) {
    final attachmentsState = ref.read(attachmentsProvider.notifier);
    final String attachmentsPath = p.join(
        attachmentsState.getParentDirPath(parentId: t.parentId?.id.toString()),
        t.id.id);
    return t.copyWith(attachDirPath: attachmentsPath);
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

  Future<void> unarchiveTodo({required UniqueId id}) async {
    final archive = ref.read(archiveProvider);
    try {
      await archive.unarchive(id);
    } catch (e) {
      ref.read(snackbarProvider).show(e.toString());
    }
    state = [];
    getTodos();
  }

  Future<void> duplicateTodo({required UniqueId id}) async {
    final archive = ref.read(archiveProvider);
    try {
      await archive.unarchive(id);
      final ToDo todo = await loadSingleTodo(id);
      ref.read(todoEditorProvider.notifier).setTodo(todo);
    } catch (e) {
      ref.read(snackbarProvider).show(e.toString());
    }
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

  Future<ToDo> loadSingleTodo(UniqueId id) async {
    try {
      final map = await db?.getItemByFieldValue(
          request: {"id": id.toString()}, table: tableName);
      if (map == null) {
        throw Exception("Cannot open todo id = $id");
      }
      return ToDo.fromMap(map);
    } on Exception {
      rethrow;
    }
  }

  int getLowestPriorityOfSameDayTodos({required ToDo todo}) {
    final todosWithSameDate = _getTodosWithSameDate(todo: todo);
    if (todosWithSameDate.isEmpty) return 1;
    return todosWithSameDate.length;
  }

  void updatePrioritiesOfSameDayTodos(
      {required ToDo todoWithNewPriority}) async {
    final newPriority = todoWithNewPriority.priority;
    final todosWithSameDate = _getTodosWithSameDate(todo: todoWithNewPriority);
    if (todosWithSameDate.isEmpty) return;

    final idx = todosWithSameDate.indexWhere((e) => newPriority == e.priority);
    if (idx != -1) {
      final i = idx >= newPriority - 1 ? idx : idx + 1;
      todosWithSameDate.insert(i, todoWithNewPriority);
      for (int priorityOfTodo = 1;
          priorityOfTodo <= todosWithSameDate.length;
          priorityOfTodo++) {
        if (priorityOfTodo == newPriority) continue;
        final currentTodo = todosWithSameDate[priorityOfTodo - 1];
        final upTodo = currentTodo.copyWith(priority: priorityOfTodo);
        updateTodo(item: upTodo);
      }
    }
  }

  List<ToDo> _getTodosWithSameDate({required ToDo todo}) {
    final d = todo.date;
    if (d == null) return [];
    final sameTodos = state.where((element) {
      if (element.date == null) return false;
      return element.date?.compareTo(d) == 0 && element.id != todo.id;
    }).toList();
    sameTodos.sort((a, b) {
      return a.priority.compareTo(b.priority);
    });
    return sameTodos;
  }

  void updateTodoPriority({required ToDo todo, required int newPriority}) {
    final todoWithNewPriority = todo.copyWith(priority: newPriority);
    updateTodo(item: todoWithNewPriority);
    updatePrioritiesOfSameDayTodos(todoWithNewPriority: todoWithNewPriority);
  }
}

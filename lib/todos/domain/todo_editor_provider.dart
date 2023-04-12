import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final todoEditorProvider = StateNotifierProvider<TodoEditorNotifier, ToDo?>(
    (ref) => TodoEditorNotifier(ref));

class TodoEditorNotifier extends StateNotifier<ToDo?> {
  TodoEditorNotifier(this.ref) : super(null);
  StateNotifierProviderRef<TodoEditorNotifier, ToDo?> ref;

  setTodo(ToDo t) {
    final todoWithUpdatedPath =
        ref.read(attachmentsProvider.notifier).manage(todo: t);
    if (todoWithUpdatedPath != null) {
      state = todoWithUpdatedPath;
    }
    state = t;
  }

  setById(UniqueId id) {
    final t =
        ref.watch(todosProvider).firstWhere((element) => element.id == id);
    setTodo(t);
  }

  updateTodo(ToDo t) async {
    bool fl = true;
    try {
      state = await ref.read(todosProvider.notifier).updateTodo(item: t);
    } on Exception catch (e) {
      ref.read(snackbarProvider).show('$e');
      fl = false;
    }
    if (fl) {
      ref.read(snackbarProvider).show("Saved");
    }
  }

  changeTodoParent(UniqueId? parentId) async {
    final todo = state;
    if (todo != null) {
      if (parentId != null && (isChild(parentId) || parentId == todo.id)) {
        throw Exception("Cannot move todo to self or own child");
      }
      try {
        final newDir = ref.read(attachmentsProvider.notifier).moveAttachments(
            oldPath: todo.attachDirPath, newParent: parentId?.id);

        late ToDo updatedTodo;
        if (parentId == null) {
          updatedTodo =
              todo.copyWith(clearParent: true, attachDirPath: newDir.path);
        } else {
          updatedTodo =
              todo.copyWith(parentId: parentId, attachDirPath: newDir.path);
        }

        await updateTodo(updatedTodo);

        final oldParent = todo.parentId;
        if (oldParent != null) {
          ref.read(todosProvider.notifier).updateTodoChildren(id: oldParent);
        }
      } on Exception {
        rethrow;
      }
    }
  }

  bool isChild(parentId) => ref
      .read(todosProvider.notifier)
      .hasChild(node: state!.id, child: parentId);

  updateTodoState(
      {UniqueId? id,
      String? title,
      String? description,
      bool? done,
      UniqueId? parentId,
      List<UniqueId>? children,
      String? attachDirPath,
      List<String>? attacments,
      List<UniqueId>? tags,
      DateTime? date,
      List<UsedPart>? usedParts}) {
    state = state?.copyWith(
      id: id,
      title: title,
      description: description,
      done: done,
      parentId: parentId,
      children: children,
      attachDirPath: attachDirPath,
      attacments: attacments,
      tags: tags,
      date: date,
      usedParts: usedParts,
    );
  }
}

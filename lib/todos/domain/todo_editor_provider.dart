import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final todoEditorProvider = StateNotifierProvider<TodoEditorNotifier, ToDo?>(
    (ref) => TodoEditorNotifier(ref));

final editIdProvider = StateProvider<bool>((ref) => false);

class TodoEditorNotifier extends StateNotifier<ToDo?> {
  TodoEditorNotifier(this.ref) : super(null);
  StateNotifierProviderRef<TodoEditorNotifier, ToDo?> ref;
  bool _isChanged = false;
  bool _duplicateMode = false;
  ToDo? _originalTodo;

  duplicateTodo(ToDo t) {
    _duplicateMode = true;
    setTodo(t);
  }

  setTodo(
    ToDo t, {
    editId = false,
  }) {
    _originalTodo = t;
    ref.read(editIdProvider.notifier).state = editId;
    final newAttachmentsPath = ref.read(attachmentsProvider.notifier).manage(
          id: t.id.id,
          attachmentsDirPath: t.attachDirPath,
          parentId: t.parentId?.id,
        );
    if (newAttachmentsPath != null) {
      state = t.copyWith(attachDirPath: newAttachmentsPath);
    }
    state = t;
  }

  changeState(ToDo t) {
    _isChanged = true;
    state = t;
  }

  setById(UniqueId id) {
    final t =
        ref.watch(todosProvider).firstWhere((element) => element.id == id);
    setTodo(t);
  }

  updateTodo(ToDo t) async {
    bool fl = true;
    _isChanged = false;
    final originalTodo = _originalTodo;
    final editId = ref.read(editIdProvider);
    try {
      if (originalTodo != null &&
          (originalTodo.priority != t.priority ||
              originalTodo.date != t.date)) {
        ref
            .read(todosProvider.notifier)
            .updatePrioritiesOfSameDayTodos(todoWithNewPriority: t);
      }

      setTodo(await ref
          .read(todosProvider.notifier)
          .updateTodo(item: t, editId: editId));
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

  checkIfToSave(GoRouter router, BuildContext context) async {
    if (!_isChanged) {
      router.pop();
      return;
    }
    final shouldSave = await confirmDialog(context, title: "Save changes?");
    if (shouldSave == null) return;
    final todo = state;
    if (shouldSave) {
      if (todo != null) {
        updateTodo(todo);
      }
    } else {
      if (_duplicateMode && todo != null) {
        ref.read(todosProvider.notifier).deleteTodo(todo: todo);
      }
    }
    router.pop();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/attachements_provider.dart';
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
    _setAttchPatch(t);
    state = t;
  }

  setById(UniqueId id) {
    final t =
        ref.watch(todosProvider).firstWhere((element) => element.id == id);
    _setAttchPatch(t);
    state = t;
  }

  updateTodo(ToDo t) async {
    bool fl = true;
    try {
      await ref.read(todosProvider.notifier).updateTodo(item: t);
    } on Exception catch (e) {
      ref.read(snackbarProvider).show('$e');
      fl = false;
    }
    if (fl) {
      ref.read(snackbarProvider).show("Saved");
    }
  }

  _setAttchPatch(ToDo t) {
    ref
        .read(attachementsProvider.notifier)
        .load(attachs: t.attacments, attachementsFolder: t.attachDirPath);
  }

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

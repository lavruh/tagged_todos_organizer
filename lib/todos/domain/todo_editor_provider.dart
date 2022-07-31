import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/attachements_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
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

  updateTodo(ToDo t) {
    final String attachementsPath =
        p.join(getParentDirPath(parentId: t.parentId?.id.toString()), t.id.id);
    Directory(attachementsPath).createSync();
    final attachementsList = ref.read(attachementsProvider);
    final updatedItem = t.copyWith(
      attachDirPath: attachementsPath,
      attacments: attachementsList,
    );
    ref.read(todosProvider.notifier).updateTodo(item: updatedItem);
    _setAttchPatch(updatedItem);
    // state = updatedItem;
    ref.read(snackbarProvider).show("Saved");
  }

  String getParentDirPath({String? parentId}) {
    final root = Directory(ref.read(appPathProvider));
    if (parentId == null) {
      return p.join(root.path, 'todos');
    }
    for (final item in root.listSync(recursive: true)) {
      if (p.basename(item.path) == parentId) {
        return item.path;
      }
    }
    throw (Exception('No item with id $parentId found'));
  }

  _setAttchPatch(ToDo t) {
    ref
        .read(attachementsProvider.notifier)
        .load(attachs: t.attacments, attachementsFolder: t.attachDirPath);
  }
}

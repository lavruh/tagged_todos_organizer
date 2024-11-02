import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todo_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/widgets/day_view_item_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/domain/datetime_extension.dart';

final oneDayViewProvider =
    StateNotifierProvider<OneDayViewNotifier, List<Widget>>((ref) {
  final notifier = OneDayViewNotifier(ref);
  notifier.updateView();
  return notifier;
});

class OneDayViewNotifier extends StateNotifier<List<Widget>> {
  OneDayViewNotifier(this.ref) : super([]);
  final Ref ref;

  updateView() {
    final tmpTodos = ref.watch(tmpTodoProvider);
    final permanentTodos = ref.watch(todosProvider).where((e) {
      if (e.date == null) return false;
      return e.date?.isSameDate(DateTime.now()) ?? false;
    }).toList();

    permanentTodos.sort((a, b) {
      return a.priority.compareTo(b.priority);
    });

    final tmpProvider = ref.read(tmpTodoProvider.notifier);
    final todoProvider = ref.read(todosProvider.notifier);
    final editor = ref.read(todoEditorProvider.notifier);

    state = [
      ...tmpTodos.map((e) => DayViewItemWidget(
            key: Key(e.id.id),
            item: e,
            onUpdate: (newValue) => tmpProvider.updateTmpTodo(newValue),
            onRemove: tmpProvider.removeTmpTodo,
            onCreatePermanent: (newValue, openEditor) async {
              final item =
                  await todoProvider.updateTodo(item: newValue, editId: true);
              tmpProvider.removeTmpTodo(newValue);
              editor.setTodo(item);
              openEditor();
            },
            isTmpTodo: true,
          )),
      ...permanentTodos.map((e) => DayViewItemWidget(
            key: Key(e.id.id),
            item: e,
            onUpdate: (newValue) => todoProvider.updateTodo(item: newValue),
            onOpenInEditor: (newVal, openEditor) {
              editor.setTodo(newVal);
              openEditor();
            },
            isTmpTodo: false,
          ))
    ];
  }
}

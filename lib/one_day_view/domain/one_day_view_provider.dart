import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todo_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/widgets/day_view_item_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/domain/datetime_extension.dart';

import '../../notifications/domain/notifications_provider.dart';
part 'one_day_view_provider.g.dart';

@riverpod
List<Widget> oneDayViewImportantUrgent(Ref ref) {
  return updateView(ref: ref, filter: (e) => e.priority < 5 && e.urgency < 5);
}

@riverpod
List<Widget> oneDayViewImportantNotUrgent(Ref ref) {
  return updateView(ref: ref, filter: (e) => e.priority < 5 && e.urgency >= 5);
}

@riverpod
List<Widget> oneDayViewNotImportantUrgent(Ref ref) {
  return updateView(ref: ref, filter: (e) => e.priority >= 5 && e.urgency < 5);
}

@riverpod
List<Widget> oneDayViewNotImportantNotUrgent(Ref ref) {
  return updateView(ref: ref, filter: (e) => e.priority >= 5 && e.urgency >= 5);
}

List<Widget> updateView(
    {required Ref ref, required bool Function(ToDo) filter}) {
  final tmpTodos = ref.watch(tmpTodoProvider).where((e) => filter(e));
  final permanentTodos = ref.watch(todosProvider).where((e) {
    if (e.date == null) return false;
    final isSameDate = e.date?.isSameDate(DateTime.now()) ?? false;
    return isSameDate && filter(e);
  }).toList();

  permanentTodos.sort((a, b) {
    return a.priority.compareTo(b.priority);
  });

  final tmpProvider = ref.read(tmpTodoProvider.notifier);
  final todoProvider = ref.read(todosProvider.notifier);
  final editor = ref.read(todoEditorProvider.notifier);
  ref.read(notificationsProvider);

  final tmp = [
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
  return tmp;
}

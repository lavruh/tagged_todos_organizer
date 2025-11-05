import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/notifications/presentation/widget/notification_schedule_dialog.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_menu_widget.dart';
import 'package:tagged_todos_organizer/utils/domain/todo_color_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class DayViewItemWidget extends StatelessWidget {
  const DayViewItemWidget({
    super.key,
    required this.item,
    required this.onUpdate,
    this.onRemove,
    this.onCreatePermanent,
    this.onOpenInEditor,
    required this.isTmpTodo,
  });
  final ToDo item;
  final bool isTmpTodo;
  final Function(ToDo) onUpdate;
  final Function(ToDo)? onRemove;
  final Future Function(ToDo, Function openEditor)? onCreatePermanent;
  final Function(ToDo, Function openEditor)? onOpenInEditor;

  @override
  Widget build(BuildContext context) {
    final suffixPanel = [
      if (isTmpTodo) ...getTmpTodoActions(context),
      if (!isTmpTodo) ...getPermanentTodoActions(context),
      SlidableAction(
        onPressed: (context) => _priorityMenuDialog(context),
        icon: Icons.priority_high,
      ),
      SlidableAction(
          onPressed: (context) =>
              showNotificationScheduleDialog(context, todo: item),
          icon: Icons.alarm_add),
    ];

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.75,
        motion: const BehindMotion(),
        children: suffixPanel,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color:
              item.done ? Colors.grey[150] : getColorForPriority(item.priority),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeTextField(
                controller: TextEditingController(text: item.title),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    decoration: item.done ? TextDecoration.lineThrough : null),
                minFontSize: 8,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                ),
                onSubmitted: (v) => onUpdate(item.copyWith(title: v)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  decoration:
                      const BoxDecoration(border: Border(left: BorderSide())),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldWithConfirm(
                        key: ValueKey(item.description.hashCode),
                        text: item.description,
                        textStyle: const TextStyle(fontSize: 9),
                        border: InputBorder.none,
                        confirmButtonLocation: Axis.vertical,
                        onConfirm: (v) =>
                            onUpdate(item.copyWith(description: v)),
                      ),
                      Consumer(builder: (context, ref, child) {
                        if (item.children.isEmpty) return Container();
                        final children =
                            ref.read(subTodosProvider(item.id)).map((e) {
                          return DayViewItemWidget(
                              item: e,
                              onUpdate: onUpdate,
                              onOpenInEditor: onOpenInEditor,
                              onRemove: onRemove,
                              isTmpTodo: isTmpTodo);
                        });
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: children.toList());
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _priorityMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: PriorityMenuWidget(
          item: item,
          onConfirm: (todo) {
            onUpdate(todo);
          },
        ));
      },
    );
  }

  List<Widget> getTmpTodoActions(BuildContext context) {
    return [
      SlidableAction(
          onPressed: (context) {
            onCreatePermanent?.call(
                item, () => context.go('/TodoEditorScreen'));
          },
          icon: Icons.add),
      SlidableAction(
          onPressed: (context) => onRemove?.call(item),
          icon: Icons.delete_forever)
    ];
  }

  List<Widget> getPermanentTodoActions(BuildContext context) {
    return [
      SlidableAction(
        onPressed: (context) =>
            onOpenInEditor?.call(item, () => context.go('/TodoEditorScreen')),
        icon: Icons.note_alt,
      ),
    ];
  }
}

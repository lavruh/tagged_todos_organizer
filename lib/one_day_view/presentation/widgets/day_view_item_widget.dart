import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/notifications/presentation/widget/notification_schedule_dialog.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_menu_widget.dart';
import 'package:tagged_todos_organizer/utils/domain/todo_color_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class DayViewItemWidget extends StatefulWidget {
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
  State<DayViewItemWidget> createState() => _DayViewItemWidgetState();
}

class _DayViewItemWidgetState extends State<DayViewItemWidget> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    final suffixPanel = [
      SlidableAction(
        onPressed: (context) =>
            setState(() => showDescription = !showDescription),
        icon: showDescription ? Icons.expand_less : Icons.expand_more,
      ),
      if (widget.isTmpTodo) ...getTmpTodoActions(context),
      if (!widget.isTmpTodo) ...getPermanentTodoActions(context),
      SlidableAction(
        onPressed: (context) => _priorityMenuDialog(context),
        icon: Icons.priority_high,
      ),
      SlidableAction(
          onPressed: (context) =>
              showNotificationScheduleDialog(context, todo: widget.item),
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
          color: widget.item.done
              ? Colors.grey[150]
              : getColorForPriority(widget.item.priority),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeTextField(
                controller: TextEditingController(text: widget.item.title),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    decoration: widget.item.done
                        ? TextDecoration.lineThrough
                        : null),
                minFontSize: 8,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                ),
                onSubmitted: (v) =>
                    widget.onUpdate(widget.item.copyWith(title: v)),
              ),
              if (showDescription)
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
                          key: ValueKey(widget.item.description.hashCode),
                          text: widget.item.description,
                          textStyle: const TextStyle(fontSize: 9),
                          border: InputBorder.none,
                          confirmButtonLocation: Axis.vertical,
                          onConfirm: (v) => widget
                              .onUpdate(widget.item.copyWith(description: v)),
                        ),
                        Consumer(builder: (context, ref, child) {
                          if (widget.item.children.isEmpty) return Container();
                          final children = ref
                              .read(subTodosProvider(widget.item.id))
                              .map((e) {
                            return DayViewItemWidget(
                                item: e,
                                onUpdate: widget.onUpdate,
                                onOpenInEditor: widget.onOpenInEditor,
                                onRemove: widget.onRemove,
                                isTmpTodo: widget.isTmpTodo);
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
          item: widget.item,
          onConfirm: (todo) {
            widget.onUpdate(todo);
          },
        ));
      },
    );
  }

  List<Widget> getTmpTodoActions(BuildContext context) {
    return [
      SlidableAction(
          onPressed: (context) {
            widget.onCreatePermanent?.call(
                widget.item, () => context.go('/TodoEditorScreen'));
          },
          icon: Icons.add),
      SlidableAction(
          onPressed: (context) => widget.onRemove?.call(widget.item),
          icon: Icons.delete_forever)
    ];
  }

  List<Widget> getPermanentTodoActions(BuildContext context) {
    return [
      SlidableAction(
        onPressed: (context) => widget.onOpenInEditor
            ?.call(widget.item, () => context.go('/TodoEditorScreen')),
        icon: Icons.note_alt,
      ),
    ];
  }
}

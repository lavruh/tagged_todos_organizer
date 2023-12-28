import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/postpone_menu.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_menu_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';

class TodoPrevWidget extends ConsumerWidget {
  const TodoPrevWidget({
    super.key,
    this.onTapTitle,
    this.onTapSubTaskCount,
    required this.item,
  });
  final ToDo item;
  final Function()? onTapTitle;
  final Function()? onTapSubTaskCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleMedium;

    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
            icon: Icons.archive,
            backgroundColor: Colors.orangeAccent,
            onPressed: (_) => _archiveTodoProcess(_, ref)),
        SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (_) => _deleteTodoProcess(_, ref)),
      ]),
      child: Card(
        color: Colors.white
            .withBlue(255 - item.priority * 7)
            .withGreen(255 - item.priority * 5),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    child: Text(
                      item.title != '' ? item.title : 'Title',
                      overflow: TextOverflow.ellipsis,
                      style: item.done
                          ? style?.copyWith(
                              decoration: TextDecoration.lineThrough)
                          : style,
                    ),
                    onTap: () => onTapTitle != null
                        ? onTapTitle!()
                        : _openInEditor(ref, context),
                  ),
                ),
                if (item.date != null)
                  TextButton(
                    key: const Key('todoPreviewDate'),
                    onPressed: () => _postponeTodoDialog(context),
                    child: Text(DateFormat('y-MM-dd').format(item.date!)),
                  ),
              ],
            ),
            Text(item.description.split('\n').last),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.children.isNotEmpty)
                  SizedBox.square(
                    dimension: 40,
                    child: TextButton(
                      key: const Key('todoSubTaskCount'),
                      onPressed: onTapSubTaskCount,
                      child: Text("${item.children.length}"),
                    ),
                  ),
                TagsPreviewWidget(tags: item.tags),
                TextButton(
                    onPressed: () => _priorityMenuDialog(context),
                    child: Text('${item.priority}')),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void _deleteTodoProcess(BuildContext context, WidgetRef ref) async {
    final act = await confirmDialog(context, title: 'Delete todo?');
    if (act == true) {
      ref.read(todosProvider.notifier).deleteTodo(todo: item);
    }
  }

  void _postponeTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: PostponeMenuWidget(item: item)),
    );
  }

  void _priorityMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: PriorityMenuWidget(item: item)),
    );
  }

  void _openInEditor(WidgetRef ref, BuildContext context) {
    {
      ref.read(todoEditorProvider.notifier).setTodo(item);
      context.go('/TodoEditorScreen');
    }
  }

  _archiveTodoProcess(BuildContext context, WidgetRef ref) async {
    final act = await confirmDialog(context, title: "Archive todo?");
    if (act == true) {
      ref.read(todosProvider.notifier).archiveTodo(todo: item);
    }
  }
}

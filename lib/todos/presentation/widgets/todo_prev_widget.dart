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
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';

class TodoPrevWidget extends ConsumerWidget {
  const TodoPrevWidget({Key? key, required this.item}) : super(key: key);
  final ToDo item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        elevation: 3,
        child: ListTile(
          leading: Checkbox(
            onChanged: (val) => _toggleDone(val, ref),
            value: item.done,
          ),
          title: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    child: Text(
                      item.title != '' ? item.title : 'Title',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _openInEditor(ref, context),
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
          ),
          subtitle: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(item.description.split('\n').last),
              TagsPreviewWidget(tags: item.tags),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTodoProcess(BuildContext context, WidgetRef ref) async {
    final act = await confirmDialog(context, title: 'Delete todo?');
    if (act) {
      ref.read(todosProvider.notifier).deleteTodo(todo: item);
    }
  }

  void _toggleDone(bool? value, WidgetRef ref) {
    if (value != null) {
      ref
          .read(todosProvider.notifier)
          .setTodoDoneUndone(value: value, todo: item);
    }
  }

  void _postponeTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: PostponeMenuWidget(item: item)),
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
    if (act) {
      ref.read(todosProvider.notifier).archiveTodo(todo: item);
    }
  }
}

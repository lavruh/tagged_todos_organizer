import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/postpone_menu.dart';

class TodoPrevWidget extends ConsumerWidget {
  const TodoPrevWidget({Key? key, required this.item}) : super(key: key);
  final ToDo item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (_) => _deleteTodoProcess(_, ref))
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
                    onPressed: () => _postponeTodoDialog(context),
                    child: Text(DateFormat('y-MM-dd').format(item.date!)),
                  ),
              ],
            ),
          ),
          subtitle: TagsPreviewWidget(tags: item.tags),
        ),
      ),
    );
  }

  void _deleteTodoProcess(BuildContext context, WidgetRef ref) async {
    final bool act = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete todo?'),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.check)),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.cancel)),
              ],
            ));
    if (act) {
      ref.read(todosProvider.notifier).deleteTodo(todo: item);
    }
  }

  void _toggleDone(bool? value, WidgetRef ref) {
    if (value != null) {
      final newItem = item.copyWith(done: value);
      ref.read(todosProvider.notifier).updateTodo(item: newItem);
      if (item.parentId != null) {
        ref.read(subTodosProvider(item.parentId!));
      }
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
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TodoEditScreen(),
      ));
    }
  }
}

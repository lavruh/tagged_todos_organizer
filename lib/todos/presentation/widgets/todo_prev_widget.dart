import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
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
          onPressed: (_) async {
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
          },
        )
      ]),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Checkbox(
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(todosProvider.notifier)
                    .updateTodo(item: item.copyWith(done: value));
              }
            },
            value: item.done,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  item.title != '' ? item.title : 'Title',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.date != null)
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          Dialog(child: PostponeMenuWidget(item: item)),
                    );
                  },
                  child: Text(DateFormat('y-MM-dd').format(item.date!)),
                ),
            ],
          ),
          subtitle: TagsPreviewWidget(tags: item.tags),
          onTap: () {
            ref.read(todoEditorProvider.notifier).setTodo(item);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const TodoEditScreen(),
            ));
          },
        ),
      ),
    );
  }
}

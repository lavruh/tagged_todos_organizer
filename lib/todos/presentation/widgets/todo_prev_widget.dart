import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';

class TodoPrevWidget extends ConsumerWidget {
  const TodoPrevWidget({Key? key, required this.item}) : super(key: key);
  final ToDo item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
            Text(item.title != '' ? item.title : 'Title'),
            if (item.date != null)
              Text(DateFormat('y-MM-dd').format(item.date!))
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description != '' ? item.description : 'Description'),
            TagsPreviewWidget(tags: item.tags),
          ],
        ),
        onTap: () {
          ref.read(todoEditorProvider.notifier).setTodo(item);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TodoEditScreen(),
          ));
        },
      ),
    );
  }
}

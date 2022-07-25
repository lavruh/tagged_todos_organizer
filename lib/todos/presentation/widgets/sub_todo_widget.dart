import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';

class SubTodoWudget extends ConsumerWidget {
  const SubTodoWudget({Key? key, required this.todo}) : super(key: key);
  final ToDo todo;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: todo.done
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(todo.title),
      onTap: () async {
        ref.read(todoEditorProvider.notifier).setTodo(todo);
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TodoEditScreen()));
      },
    );
  }
}

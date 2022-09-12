import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class SubTodosOverviewWidget extends ConsumerWidget {
  const SubTodosOverviewWidget({Key? key, required this.parentId})
      : super(key: key);
  final UniqueId parentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(subTodosProvider(parentId));
    return Card(
        child: ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Sub tasks (${todos.length}) :'),
          IconButton(
              onPressed: () {
                final item = ToDo.empty().copyWith(parentId: parentId);
                ref.read(todoEditorProvider.notifier).setTodo(item);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TodoEditScreen()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Flexible(
            child: ListView(
              children: todos.map((e) => TodoPrevWidget(item: e)).toList(),
            ),
          ),
        ),
      ],
    ));
  }
}

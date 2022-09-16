import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';

class SubTodosOverviewWidget extends ConsumerWidget {
  const SubTodosOverviewWidget({Key? key, required this.parent})
      : super(key: key);
  final ToDo parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(subTodosProvider(parent.id));
    return Card(
        child: ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Sub tasks (${todos.length}) :'),
          IconButton(
              onPressed: () {
                final item = ToDo.empty().copyWith(
                  parentId: parent.id,
                  tags: parent.tags,
                );
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

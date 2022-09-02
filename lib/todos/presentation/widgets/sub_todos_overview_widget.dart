import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  ref.read(todosProvider.notifier).addSubTodo(parentId);
                },
                child: const Text('Add subtask')),
            Flexible(
              child: ListView(
                children: todos.map((e) => TodoPrevWidget(item: e)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

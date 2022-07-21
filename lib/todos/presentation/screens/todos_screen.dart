import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TagsEditScreen(),
                ));
              },
              icon: const Icon(Icons.label)),
          IconButton(
            onPressed: () => ref.read(todosProvider.notifier).addTodo(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Text('${ref.watch(todosProvider)}'),
    );
  }
}

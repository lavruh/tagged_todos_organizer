import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

class TodoEditScreen extends ConsumerWidget {
  const TodoEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(todoEditorProvider);
    if (item == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final title = TextEditingController(text: item.title);
    final description = TextEditingController(text: item.description);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(todosProvider.notifier).updateTodo(item: item);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onFieldSubmitted: (value) {
                  ref
                      .read(todoEditorProvider.notifier)
                      .update((state) => item.copyWith(title: value));
                },
              ),
              TextFormField(
                controller: description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                onFieldSubmitted: (value) {
                  ref
                      .read(todoEditorProvider.notifier)
                      .update((state) => item.copyWith(description: value));
                },
              ),
              TagsWidget(
                tags: item.tags,
                updateTags: (t) {
                  ref
                      .read(todoEditorProvider.notifier)
                      .update((state) => item.copyWith(tags: t));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

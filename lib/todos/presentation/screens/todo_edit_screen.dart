import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachemets_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class TodoEditScreen extends ConsumerWidget {
  const TodoEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 200)));
      }
    });

    final item = ref.watch(todoEditorProvider);
    if (item == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final title = TextEditingController(text: item.title);
    final description = TextEditingController(text: item.description);
    return WillPopScope(
      onWillPop: () async => _goToTodosScreen(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (item.parentId != null)
              TextButton(
                  onPressed: () {
                    if (item.parentId != null) {
                      ref
                          .read(todoEditorProvider.notifier)
                          .setById(item.parentId!);
                    }
                  },
                  child: const Text('Go parent',
                      style: TextStyle(color: Colors.white))),
            IconButton(
                onPressed: () {
                  ref.read(todosProvider.notifier).deleteTodo(todo: item);
                  _goToTodosScreen(context);
                },
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () =>
                  ref.read(todoEditorProvider.notifier).updateTodo(item),
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: ListView(
              children: [
                Row(children: [
                  Checkbox(
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(todoEditorProvider.notifier)
                            .setTodo(item.copyWith(done: value));
                      }
                    },
                    value: item.done,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      onFieldSubmitted: (value) {
                        ref
                            .read(todoEditorProvider.notifier)
                            .setTodo(item.copyWith(title: value));
                      },
                    ),
                  ),
                ]),
                TextFormField(
                  controller: description,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onFieldSubmitted: (value) {
                    ref
                        .read(todoEditorProvider.notifier)
                        .setTodo(item.copyWith(description: value));
                  },
                ),
                TagsWidget(
                  tags: item.tags,
                  updateTags: (t) {
                    ref
                        .read(todoEditorProvider.notifier)
                        .setTodo(item.copyWith(tags: t));
                  },
                ),
                const AttachementsPreviewWidget(),
                SubTodosOverviewWidget(parentId: item.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _goToTodosScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TodosScreen()));
    return true;
  }
}

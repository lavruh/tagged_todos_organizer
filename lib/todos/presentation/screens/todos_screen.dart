import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final date = await showDialog(
                    context: context,
                    builder: (context) => DatePickerDialog(
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 3),
                        lastDate: DateTime(DateTime.now().year + 3)));
                ref.read(todosFilterByDate.notifier).update((state) => date);
              },
              icon: const Icon(Icons.calendar_month)),
          IconButton(
              onPressed: () {
                ref.read(tagsFilter.notifier).update((state) => '');
                ref.read(tagEditorProvider.notifier).update((state) => null);
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
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, i) {
          return TodoPrevWidget(item: todos[i]);
        },
      ),
      floatingActionButton: SearchPanelWidget(
        onSearch: (v) {
          ref.read(todosFilter.notifier).update((state) => v);
        },
        tagsFilter: true,
      ),
    );
  }
}

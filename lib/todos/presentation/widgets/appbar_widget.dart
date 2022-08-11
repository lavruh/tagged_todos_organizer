import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () async {
              final flag = ref.read(todosFilterShowUnDone);
              ref.read(todosFilterShowUnDone.notifier).update((state) => !flag);
            },
            icon: ref.watch(todosFilterShowUnDone)
                ? const Icon(Icons.check_box_outline_blank)
                : const Icon(Icons.check_box)),
        IconButton(
            onPressed: () async {
              final flag = ref.read(todosFilterShowAll);
              ref.read(todosFilterShowAll.notifier).update((state) => !flag);
            },
            icon: ref.watch(todosFilterShowAll)
                ? const Icon(Icons.account_tree)
                : const Icon(Icons.account_tree_outlined)),
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
          onPressed: () {
            final item = ToDo.empty();
            ref.read(todoEditorProvider.notifier).setTodo(item);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TodoEditScreen()));
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

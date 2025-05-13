import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      actions: [
        TextButton(
          child: const Text("Plans for today"),
          onPressed: () => context.go('/OneDayViewScreen'),
        ),
        IconButton(
          onPressed: () => _createNewTodo(ref, context),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  void _createNewTodo(WidgetRef ref, BuildContext context) {
    final item = ToDo.empty();
    final selectedTags = ref.read(filterByTagsProvider);
    if (selectedTags.isNotEmpty) {
      ref
          .read(todoEditorProvider.notifier)
          .setTodo(item.copyWith(tags: selectedTags));
    } else {
      ref.read(todoEditorProvider.notifier).setTodo(item);
    }
    context.go('/TodoEditorScreen');
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

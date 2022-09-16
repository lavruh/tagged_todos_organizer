import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/appbar_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: [
                ...todos.map(
                  (e) => TodoPrevWidget(item: e),
                ),
              ],
            ),
          ),
          SearchPanelWidget(
            onSearch: (v) {
              ref.read(todosFilter.notifier).update((state) => v);
            },
            tagsFilter: true,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/filter_menu_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';

class TodoSelectScreen extends ConsumerWidget {
  const TodoSelectScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('/');
              },
              child: const Text(
                'Move to root',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      endDrawer: const FilterMenuWidget(),
      body: Column(
        children: [
          Flexible(
              child: ListView(
            children: ref
                .watch(filteredTodosProvider)
                .map((e) => TodoPrevWidget(
                      item: e,
                      onTapTitle: () {
                        Navigator.of(context).pop(e.id);
                      },
                    ))
                .toList(),
          )),
          SearchPanelWidget(
            key: const Key('TodoSearchPanel'),
            initSearchText: ref.read(todosFilter),
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

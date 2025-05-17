import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_from_string_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_row_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/appbar_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/filter_menu_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/menu_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_tree_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 3000)));
      }
    });

    // ensure necessary providers are initialized
    ref.watch(tagsAliasesProvider);


    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuWidget(),
      endDrawer: const FilterMenuWidget(),
      body: Column(
        children: [
          const Flexible(
              child: TodoTreeWidget(
            key: Key('TodosOverview'),
          )),
          const TagsRowWidget(),
          SearchPanelWidget(
            key: const Key('TodoSearchPanel'),
            initSearchText: ref.read(todosFilter),
            onSearch: (v) {
              ref.read(todosFilter.notifier).update((state) => v);
              ref
                  .read(tagsFromStringSearchProvider.notifier)
                  .update((state) => v);
            },
            tagsFilter: true,
          ),
        ],
      ),
    );
  }
}

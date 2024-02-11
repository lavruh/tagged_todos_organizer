import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/filtered_log_provider.dart';
import 'package:tagged_todos_organizer/log/presentation/widgets/log_entry_widget.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_from_string_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_row_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';

class LogOverviewScreen extends ConsumerWidget {
  const LogOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredLogProvider).reversed;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: items.map((e) => LogEntryWidget(entry: e)).toList(),
            ),
          ),
          const TagsRowWidget(),
          SearchPanelWidget(
            key: const Key('TodoSearchPanel'),
            onSearch: (v) {
              ref.read(logTitleFilter.notifier).update((state) => v);
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

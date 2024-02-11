import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';

final filteredLogProvider = Provider<List<LogEntry>>((ref) {
  final allLogEntries = ref.watch(logProvider);
  final titleFilter = ref.watch(logTitleFilter);
  final filterByTags = ref.watch(filterByTagsProvider);

  List<LogEntry> filteredLog = allLogEntries;

  if (filterByTags.isNotEmpty) {
    filteredLog = filteredLog.where((todo) {
      return filterByTags.every((element) => todo.tags.contains(element));
    }).toList();
  }
  return filteredLog
      .where((element) => element.title.contains(titleFilter))
      .toList();
});

final logTitleFilter = StateProvider<String>((ref) => '');

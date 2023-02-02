

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';

final filteredLogProvider = Provider<List<LogEntry>>((ref) {
  final allLogEntries = ref.watch(logProvider);
  final titleFilter = ref.watch(logTitleFilter);
  return allLogEntries.where((element) => element.title.contains(titleFilter)).toList();
});


final logTitleFilter = StateProvider<String>((ref) => '');
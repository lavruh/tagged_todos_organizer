import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/log_db_provider.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final logProvider = NotifierProvider<LogNotifier, List<LogEntry>>(() {
  return LogNotifier();
});

class LogNotifier extends Notifier<List<LogEntry>> {
  @override
  build() {
    ref.watch(logDbProvider).whenData(
          (value) => setDb(value),
        );
    getAllEntries();
    return [];
  }

  IDbService? db;
  final String table = 'log';

  void setDb(IDbService instance) {
    db = instance;
  }

  Future<void> getAllEntries() async {
    state = [];
    if (db != null) {
      await for (final map in db!.getAll(table: table)) {
        state = [...state, LogEntry.fromMap(map)];
      }
    }
  }

  void logTodoArchived({required ToDo todo}) {
    logActionWithTodo(action: LoggableAction.archived, todo: todo);
  }

  void logTodoDoneUndone({required ToDo todo, required bool done}) {
    logActionWithTodo(action: LoggableAction.done, todo: todo);
  }

  Future<void> logActionWithTodo({
    required LoggableAction action,
    required ToDo todo,
  }) async {
    final entry = LogEntry.empty().copyWith(
        title: todo.title, tags: todo.tags, relatedId: todo.id, action: action);
    await addEntry(entry);
  }

  Future<void> addEntry(LogEntry entry) async {
    state = [...state, entry];
    db?.update(id: entry.id.toString(), item: entry.toMap(), table: table);
  }
}

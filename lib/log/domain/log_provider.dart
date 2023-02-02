import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/log_db_provider.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final logProvider = StateNotifierProvider<LogNotifier, List<LogEntry>>((ref) {
  final notifier = LogNotifier(ref);
  ref.watch(logDbProvider).whenData(
        (value) => notifier.setDb(value),
      );
  notifier.getAllEntries();
  return notifier;
});

class LogNotifier extends StateNotifier<List<LogEntry>> {
  StateNotifierProviderRef<LogNotifier, List<LogEntry>> ref;
  LogNotifier(this.ref) : super([]);
  IDbService? db;
  final String table = 'log';

  setDb(IDbService instance) {
    db = instance;
  }

  getAllEntries() async {
    if (db != null) {
      await for (final map in db!.getAll(table: table)) {
        state = [...state, LogEntry.fromMap(map)];
      }
    }
  }

  logTodoCreated({required ToDo todo}) {
    logActionWithTodo(action: LoggableAction.created, todo: todo);
  }

  logTodoDoneUndone({required ToDo todo, required bool done}) {
    final action = done ? LoggableAction.done : LoggableAction.undone;
    logActionWithTodo(action: action, todo: todo);
  }

  logActionWithTodo({
    required LoggableAction action,
    required ToDo todo,
  }) async {
    final entry = LogEntry.empty().copyWith(
        title: todo.title, tags: todo.tags, relatedId: todo.id, action: action);
    await addEntry(entry);
  }

  addEntry(LogEntry entry) async {
    state = [...state, entry];
    db?.update(id: entry.id.toString(), item: entry.toMap(), table: table);
  }

  logTodoDeleted({required ToDo todo}) {
    logActionWithTodo(action: LoggableAction.deleted, todo: todo);
  }
}

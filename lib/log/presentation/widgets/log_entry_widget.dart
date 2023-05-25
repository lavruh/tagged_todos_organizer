import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class LogEntryWidget extends ConsumerWidget {
  const LogEntryWidget({Key? key, required this.entry}) : super(key: key);

  final LogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
          '${entry.title} is ${entry.action.name} @ ${DateFormat('y-MM-dd\t hh:mm:ss').format(entry.date)}'),
      subtitle: entry.action == LoggableAction.archived
          ? TextButton(
              onPressed: () {
                if(entry.relatedId != null) {
                  _unarchive(ref, id: entry.relatedId!);
                }
              },
              child: const Text('Unarchive'),
            )
          : Container(),
    );
  }

  _unarchive(WidgetRef ref, {required UniqueId id}) {
    ref.read(todosProvider.notifier).unarchiveTodo(id: id);
  }
}

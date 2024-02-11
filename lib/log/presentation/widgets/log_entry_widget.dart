import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class LogEntryWidget extends ConsumerWidget {
  const LogEntryWidget({super.key, required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              '${entry.title} is ${entry.action.name} @ ${DateFormat('y-MM-dd\t hh:mm:ss').format(entry.date)}'),
          TagsPreviewWidget(tags: entry.tags),
        ],
      ),
      subtitle: entry.action == LoggableAction.archived
          ? Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (entry.relatedId != null) {
                      _unarchive(ref, id: entry.relatedId!);
                    }
                  },
                  child: const Text('Unarchive'),
                ),
                TextButton(
                    onPressed: () {
                      if (entry.relatedId != null) {
                        _duplicate(ref, id: entry.relatedId!);
                        context.go('/TodoEditorScreen');
                      }
                    },
                    child: const Text('Duplicate')),
              ],
            )
          : Container(),
    );
  }

  _unarchive(WidgetRef ref, {required UniqueId id}) {
    ref.read(todosProvider.notifier).unarchiveTodo(id: id);
  }

  _duplicate(WidgetRef ref, {required UniqueId id}) {
    ref.read(todosProvider.notifier).duplicateTodo(id: id);
  }
}

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
              '${entry.title} is ${entry.action.name} @ ${DateFormat('y-MM-dd\t HH:mm').format(entry.date)}'),
          TagsPreviewWidget(tags: entry.tags),
        ],
      ),
      subtitle: entry.action == LoggableAction.archived
          ? Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (entry.relatedId != null) {
                      final fl = await _unarchive(ref, id: entry.relatedId!);
                      if (fl && context.mounted) {
                        context.go('/TodoEditorScreen');
                      }
                    }
                  },
                  child: const Text('Unarchive'),
                ),
              ],
            )
          : Container(),
    );
  }

  Future<bool> _unarchive(WidgetRef ref, {required UniqueId id}) async {
    return await ref.read(todosProvider.notifier).unarchiveTodo(id: id);
  }
}

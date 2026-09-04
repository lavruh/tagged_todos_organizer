import 'dart:io';

import 'package:archive/archive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tagged_todos_organizer/log/domain/archived_todo_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'package:path/path.dart' as p;

class LogPreviewScreen extends ConsumerWidget {
  final UniqueId todoId;
  const LogPreviewScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedTodo = ref.watch(archivedTodoProvider(todoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived ToDo Preview'),
      ),
      body: archivedTodo.when(
        data: (todo) => _buildContent(context, ref, todo),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ToDo todo) {
    final attachments = ref.watch(archivedAttachmentsProvider(todoId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          if (todo.date != null)
            Text(
              'Date: ${DateFormat('y-MM-dd HH:mm').format(todo.date!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: 16),
          TagsPreviewWidget(tags: todo.tags),
          const SizedBox(height: 16),
          const Text('Description:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(todo.description.isEmpty ? 'No description' : todo.description),
          const SizedBox(height: 16),
          if (todo.usedParts.isNotEmpty) ...[
            const Text('Used Parts:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...todo.usedParts.map((part) => ListTile(
                  title: Text('${part.maximoNumber}, Qty: ${part.pieces}'),
                  subtitle: Text(part.name),
                )),
            const SizedBox(height: 16),
          ],
          const Text('Attachments:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          attachments.when(
            data: (files) => files.isEmpty
                ? const Text('No attachments')
                : Column(
                    children: files
                        .map((f) => ListTile(
                              leading: const Icon(Icons.attach_file),
                              title: Text(f.name),
                              onTap: () => _openAttachment(context, f),
                            ))
                        .toList(),
                  ),
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error loading attachments: $err'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAttachment(BuildContext context, ArchiveFile file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, file.name));
      await tempFile.create(recursive: true);
      await tempFile.writeAsBytes(file.content as List<int>);

      await OpenFilex.open(tempFile.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file: $e')),
        );
      }
    }
  }
}

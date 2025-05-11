import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/input_dialog.dart';

class RenameAttachmentButton extends ConsumerWidget {
  const RenameAttachmentButton({super.key, required this.e});

  final String e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          final newName = await inputDialog(
            context,
            title: "Rename",
            text: p.basename(e),
          );
          if (newName != null && newName.isNotEmpty) {
            ref
                .read(attachmentsProvider.notifier)
                .renameAttachmentFile(filePath: e, newName: newName);
          }
        },
        icon: const Icon(Icons.drive_file_rename_outline));
  }
}

class DeleteAttachmentButton extends ConsumerWidget {
  const DeleteAttachmentButton({super.key, required this.e});

  final String e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          final confirm =
              await confirmDialog(context, title: 'Delete attachment?');
          if (confirm != null && confirm) {
            ref
                .read(attachmentsProvider.notifier)
                .deleteAttachmentFile(path: e);
          }
        },
        icon: const Icon(Icons.delete_forever));
  }
}

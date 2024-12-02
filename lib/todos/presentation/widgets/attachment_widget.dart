import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/input_dialog.dart';

class AttachmentWidget extends ConsumerWidget {
  const AttachmentWidget({super.key, required this.e});
  final String e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachments = ref.read(attachmentsProvider.notifier);

    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              final extension = p.extension(e);
              if (extension == '.jpg' || extension == '.jpeg') {
                ref.read(imagesViewProvider.notifier).openImage(e);
                context.go('/TodoEditorScreen/ImagesViewScreen');
              } else {
                attachments.openFile(file: e);
              }
            },
            child: Text(p.basename(e)),
          ),
          IconButton(
              onPressed: () async {
                final newName = await inputDialog(
                  context,
                  title: "Rename",
                  text: p.basename(e),
                );
                if(newName != null && newName.isNotEmpty) {
                  attachments.renameAttachmentFile(filePath: e, newName: newName);
                }
              },
              icon: const Icon(Icons.drive_file_rename_outline)),
          IconButton(
              onPressed: () async {
                final confirm =
                    await confirmDialog(context, title: 'Delete attachment?');
                if (confirm != null && confirm) {
                  attachments.deleteAttachmentFile(path: e);
                }
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
    );
  }
}

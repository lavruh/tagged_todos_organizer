import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:popover/popover.dart';
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';

import 'attachment_action_buttons.dart';

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
              if (extension == '.jpg' ||
                  extension == '.jpeg' ||
                  extension == '.notes') {
                ref.read(imagesViewProvider.notifier).openImage(e);
                context.go('/TodoEditorScreen/ImagesViewScreen');
              } else {
                attachments.openFile(file: e);
              }
            },
            onLongPress: () => showPopover(
                context: context,
                bodyBuilder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RenameAttachmentButton(e: e),
                      DeleteAttachmentButton(e: e)
                    ],
                  );
                }),
            child: Text(p.basename(e)),
          ),
        ],
      ),
    );
  }
}

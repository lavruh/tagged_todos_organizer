import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';

class AttachementsPreviewWidget extends ConsumerWidget {
  const AttachementsPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(attachmentsProvider);
    final attachments = ref.read(attachmentsProvider.notifier);
    return Card(
        child: ExpansionTile(
      title: Row(children: [
        Text('Attachements (${items.length}) :'),
        IconButton(
            onPressed: () => attachments.attachFile(),
            icon: const Icon(Icons.attach_file)),
        if (Platform.isAndroid)
          IconButton(
              onPressed: () => attachments.addPhoto(),
              icon: const Icon(Icons.add_a_photo)),
        IconButton(
            onPressed: () => attachments.openFolder(),
            icon: const Icon(Icons.folder_open)),
      ]),
      children: items
          .map((e) => TextButton(
                onPressed: () async {
                  final extension = p.extension(e);
                  if (extension == '.jpg' || extension == '.jpeg') {
                    ref.read(imagesViewProvider.notifier).openImage(e);
                    context.go('/TodoEditorScreen/ImagesViewScreen');
                  } else {
                    attachments.openFile(file: e);
                  }
                  attachments.updateAttachments();
                },
                child: Text(p.basename(e)),
              ))
          .toList(),
    ));
  }
}

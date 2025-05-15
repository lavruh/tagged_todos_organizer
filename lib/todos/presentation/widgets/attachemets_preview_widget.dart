import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachment_widget.dart';

class AttachementsPreviewWidget extends ConsumerWidget {
  const AttachementsPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(attachmentsProvider);
    final attachments = ref.read(attachmentsProvider.notifier);
    return Card(
      child: ExpansionTile(
          title: Row(children: [
            Text('Attachments (${items.length}) :'),
            Expanded(child: Container()),
            IconButton(
                onPressed: attachments.attachFile,
                icon: const Icon(Icons.attach_file)),
            if (Platform.isAndroid)
              IconButton(
                  onPressed: () => attachments.addPhoto(),
                  icon: const Icon(Icons.add_a_photo)),
            IconButton(
                onPressed: () => attachments.openFolder(),
                icon: const Icon(Icons.folder_open)),
          ]),
          children: [
            Wrap(children: items.map((e) => AttachmentWidget(e: e)).toList())
          ]),
    );
  }
}

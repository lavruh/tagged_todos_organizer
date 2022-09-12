import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/image_view_screen.dart';
import 'package:tagged_todos_organizer/todos/domain/attachements_provider.dart';

class AttachementsPreviewWidget extends ConsumerWidget {
  const AttachementsPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(attachementsProvider);
    return Card(
        child: ExpansionTile(
      title: Row(children: [
        Text('Attachements (${items.length}) :'),
        IconButton(
            onPressed: () =>
                ref.read(attachementsProvider.notifier).attachFile(),
            icon: const Icon(Icons.attach_file)),
        if (Platform.isAndroid)
          IconButton(
              onPressed: () =>
                  ref.read(attachementsProvider.notifier).addPhoto(),
              icon: const Icon(Icons.add_a_photo)),
        IconButton(
            onPressed: () =>
                ref.read(attachementsProvider.notifier).openFolder(),
            icon: const Icon(Icons.folder_open)),
      ]),
      children: items
          .map((e) => TextButton(
                onPressed: () async {
                  final extension = p.extension(e);
                  if (extension == '.jpg' || extension == '.jpeg') {
                    ref.read(imagesViewProvider.notifier).openImage(e);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ImagesViewScreen()),
                    );
                  } else {
                    ref.read(attachementsProvider.notifier).openFile(file: e);
                  }
                  // should update attachements list
                  ref.read(attachementsProvider.notifier).updateAttachements();
                },
                child: Text(p.basename(e)),
              ))
          .toList(),
    ));
  }
}

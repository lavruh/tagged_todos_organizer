import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:tagged_todos_organizer/todos/domain/attachements_provider.dart';

class AttachementsPreviewWidget extends ConsumerWidget {
  const AttachementsPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(attachementsProvider);
    return Card(
      child: Column(
        children: [
          Row(children: [
            const Text('Attachements:'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
            if (Platform.isAndroid)
              IconButton(
                  onPressed: () =>
                      ref.read(attachementsProvider.notifier).addPhoto(),
                  icon: const Icon(Icons.add_a_photo)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.folder_open)),
          ]),
          Wrap(
              children: items
                  .map((e) => TextButton(
                        onPressed: () async {
                          if (Platform.isLinux) {
                            final shell = Shell();
                            shell.run("xdg-open '$e'");
                          }
                          if (Platform.isAndroid) {
                            OpenFilex.open(e);
                          }
                        },
                        child: Text(p.basename(e)),
                      ))
                  .toList()),
        ],
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/main.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/app_version_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class MenuWidget extends ConsumerWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(ref.watch(appVersionProvider)),
          ),
          ListTile(
            leading: const Icon(Icons.source),
            title: const Text('Change root folder'),
            subtitle: Text(ref.watch(appPathProvider)),
            onTap: () async {
              final c = context;
              final dirPath = await FilePicker.platform.getDirectoryPath();
              if (dirPath != null) {
                if (c.mounted) {
                  RestartWidget.updateRootPathAndRestartApp(c, dirPath);
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag_sharp),
            title: const Text('Tags Editor'),
            onTap: (() {
              ref.read(tagsFilter.notifier).update((state) => '');
              ref.read(tagEditorProvider.notifier).update((state) => null);
              context.go('/TagsEditScreen');
            }),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Log'),
            onTap: () {
              context.go('/LogOverviewScreen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Update parts db'),
            onTap: () async {
              final navigator = Navigator.of(context);
              try {
                await ref.read(partsInfoProvider).initUpdatePartsFromFile();
                ref.read(snackbarProvider.notifier).show('Sucessfully updated');
              } on Exception catch (e) {
                ref
                    .read(snackbarProvider.notifier)
                    .show('Fail to update parts db : $e');
              }
              navigator.pop();
            },
          )
        ],
      ),
    );
  }
}

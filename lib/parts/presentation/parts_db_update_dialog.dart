import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

void showPartsDbUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(content: const PartsDbUpdateDialog()),
  );
}

class PartsDbUpdateDialog extends ConsumerWidget {
  const PartsDbUpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final snackbar = ref.read(snackbarProvider.notifier);
                try {
                  await ref.read(partsInfoProvider).initUpdatePartsFromFile();
                  snackbar.show('Successfully updated');
                } on Exception catch (e) {
                  snackbar.show('Fail to update parts db : $e');
                }
                navigator.pop();
              },
              child: const Text("Update parts db")),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
                value: ref.watch(partsInfoRepoUpdateProgressProvider)),
          ),
        ],
      ),
    );
  }
}

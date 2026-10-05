import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

void showPartsDbUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (context) => AlertDialog(
      title: const Text("Update parts db"),
      content: const PartsDbUpdateDialog(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

class PartsDbUpdateDialog extends ConsumerStatefulWidget {
  const PartsDbUpdateDialog({super.key});

  @override
  ConsumerState<PartsDbUpdateDialog> createState() =>
      _PartsDbUpdateDialogState();
}

class _PartsDbUpdateDialogState extends ConsumerState<PartsDbUpdateDialog> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<String>>(partsUpdateLogProvider, (previous, next) {
      if (next.length != previous?.length) {
        _scrollToBottom();
      }
    });

    final progress = ref.watch(partsInfoRepoUpdateProgressProvider);
    final logMessages = ref.watch(partsUpdateLogProvider);

    return SizedBox(
      width: 400,
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              final snackbar = ref.read(snackbarProvider.notifier);
              try {
                await ref.read(partsInfoProvider).initUpdatePartsFromFile();
                snackbar.show('Successfully updated');
              } on Exception catch (e) {
                snackbar.show('Fail to update parts db : $e');
              }
            },
            child: const Text("Update parts db"),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 10),
          const Text(
            "Log:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: logMessages.isEmpty
                  ? const Center(
                      child: Text(
                        "No log entries",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: logMessages.length,
                        itemBuilder: (context, index) {
                          final msg = logMessages[index];
                          final isError = msg.toLowerCase().contains("error") ||
                              msg.toLowerCase().contains("fail");
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            child: Text(
                              msg,
                              style: TextStyle(
                                fontSize: 12,
                                color: isError ? Colors.red : Colors.black87,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

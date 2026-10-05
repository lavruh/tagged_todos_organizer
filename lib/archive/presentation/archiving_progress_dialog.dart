import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

Future<void> showArchivingProgressDialog(
  BuildContext context, {
  required ToDo todo,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (context) => ArchivingProgressDialog(todo: todo),
  );
}

class ArchivingProgressDialog extends ConsumerStatefulWidget {
  const ArchivingProgressDialog({
    super.key,
    required this.todo,
  });

  final ToDo todo;

  @override
  ConsumerState<ArchivingProgressDialog> createState() =>
      _ArchivingProgressDialogState();
}

class _ArchivingProgressDialogState
    extends ConsumerState<ArchivingProgressDialog> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0.0;
  final List<String> _logs = [];
  bool _isDone = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startArchiving();
    });
  }

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

  Future<void> _startArchiving() async {
    final result = await ref.read(todosProvider.notifier).archiveTodo(
          todo: widget.todo,
          onProgress: (message, currentProgress) {
            if (mounted) {
              setState(() {
                _logs.add(message);
                _progress = currentProgress;
              });
              _scrollToBottom();
            }
          },
        );
    if (mounted) {
      setState(() {
        _isDone = true;
        _isSuccess = result;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Archiving ToDo"),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.todo.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: _progress),
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
                child: _logs.isEmpty
                    ? const Center(
                        child: Text(
                          "Starting archiving...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            final msg = _logs[index];
                            final isError =
                                msg.toLowerCase().contains("error") ||
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
                                  color:
                                      isError ? Colors.red : Colors.black87,
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
      ),
      actions: [
        TextButton(
          onPressed: _isDone
              ? () {
                  Navigator.of(context, rootNavigator: true).pop();
                  if (_isSuccess) {
                    GoRouter.of(context).go('/');
                  }
                }
              : null,
          child: const Text("Close"),
        ),
      ],
    );
  }
}

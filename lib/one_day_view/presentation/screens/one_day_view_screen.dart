import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/notifications/domain/notifications_provider.dart';
import 'package:tagged_todos_organizer/notifications/presentation/widget/active_notifications_dialog.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/one_day_view_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todo_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class OneDayViewScreen extends ConsumerWidget {
  const OneDayViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 3000)));
      }
    });

    final items = ref.watch(oneDayViewProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('EE, MMM dd, yyyy').format(DateTime.now())),
          actions: [
            IconButton(
              tooltip: "Get active reminders",
              icon: Icon(Icons.list_alt),
              onPressed: () {
                ref.read(notificationsProvider.notifier).getNotifications();
                showActiveNotificationsDialog(context);
              },
            ),
            IconButton(
                tooltip: "Add tmp todo",
                onPressed: () =>
                    ref.read(tmpTodoProvider.notifier).addTmpTodo(),
                icon: const Icon(Icons.add))
          ],
        ),
        body: ListView(
          key: Key(items.length.toString()),
          children: items,
        ));
  }
}

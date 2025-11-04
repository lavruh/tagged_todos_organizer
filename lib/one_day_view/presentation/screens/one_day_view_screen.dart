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

    final importantUrgent = ref.watch(oneDayViewImportantUrgentProvider);
    final importantNotUrgent = ref.watch(oneDayViewImportantNotUrgentProvider);
    final notImportantUrgent = ref.watch(oneDayViewNotImportantUrgentProvider);
    final notImportantNotUrgent =
        ref.watch(oneDayViewNotImportantNotUrgentProvider);

    final height = (MediaQuery.of(context).size.height -
            kToolbarHeight -
            MediaQuery.of(context).viewPadding.top) *
        0.5;
    final width = MediaQuery.of(context).size.width * 0.5;

    final headerStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Colors.red[50],
                    child: ListView(
                      children: [
                        Text("Urgent & Important", style: headerStyle),
                        ...importantUrgent,
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: Colors.orange[50],
                    child: ListView(children: [
                      Text("Important & Not Urgent", style: headerStyle),
                      ...importantNotUrgent,
                    ]),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Colors.green[50],
                    child: ListView(children: [
                      Text("Urgent & Not Important", style: headerStyle),
                      ...notImportantUrgent,
                    ]),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: Colors.grey[50],
                    child: ListView(children: [
                      Text("Not Urgent & Not Important", style: headerStyle),
                      ...notImportantNotUrgent,
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/notifications/domain/notifications_provider.dart';
import 'package:tagged_todos_organizer/notifications/domain/reminder.dart';
import 'package:tagged_todos_organizer/notifications/presentation/widget/reminder_widget.dart';

Future<void> showActiveNotificationsDialog(BuildContext context) async {
  showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
        icon: const Icon(Icons.notifications),
        title: Text("Scheduled reminders"),
        content: ActiveNotificationsDialog()),
  );
}

class ActiveNotificationsDialog extends ConsumerStatefulWidget {
  const ActiveNotificationsDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActiveNotificationsDialogState();
}

class _ActiveNotificationsDialogState
    extends ConsumerState<ActiveNotificationsDialog> {
  List<Reminder> notifications = [];

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(notificationsProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: reminders
            .map((e) => ReminderWidget(
                  item: e,
                  onDelete: () {
                    final id = e.id;
                    if (id != null) {
                      ref.read(notificationsProvider.notifier).cancel(id);
                    }
                  },
                ))
            .toList(),
      ),
    );
  }
}

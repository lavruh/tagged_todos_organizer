import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/notifications/domain/notifications_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

Future<void> showNotificationScheduleDialog(
  BuildContext context, {
  required ToDo todo,
}) async {
  showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
        title: Text("Create reminder"),
        content: NotificationScheduleDialog(
          todo: todo,
        )),
  );
}

class NotificationScheduleDialog extends ConsumerStatefulWidget {
  const NotificationScheduleDialog({super.key, required this.todo});
  final ToDo todo;

  @override
  _NotificationScheduleDialogState createState() =>
      _NotificationScheduleDialogState();
}

class _NotificationScheduleDialogState
    extends ConsumerState<NotificationScheduleDialog> {
  String text = "";

  @override
  void initState() {
    text = widget.todo.description.split("\n").last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWithConfirm(
              text: text,
              onConfirm: (v) {
                setState(() => text = v);
              }),
          ElevatedButton(
              onPressed: () =>
                  _scheduleReminder(now.add(const Duration(minutes: 15))),
              child: Text("In 15 minutes")),
          ElevatedButton(
              onPressed: () =>
                  _scheduleReminder(now.add(const Duration(minutes: 30))),
              child: Text("In 30 minutes")),
          ElevatedButton(
              onPressed: () =>
                  _scheduleReminder(now.add(const Duration(hours: 1))),
              child: Text("In 1 hour")),
          ElevatedButton(
              onPressed: () =>
                  _scheduleReminder(now.add(const Duration(hours: 3))),
              child: Text("In 3 hour")),
          ElevatedButton(
              onPressed: () =>
                  _scheduleReminder(now.add(const Duration(hours: 6))),
              child: Text("In 6 hour")),
          ElevatedButton(
              onPressed: () async {
                final d = await _showTimePicker(context);
                if (d != null) _scheduleReminder(d);
              },
              child: Text("Select time")),
        ],
      ),
    );
  }

  Future<DateTime?> _showTimePicker(BuildContext context) async {
    final now = DateTime.now();
    final d = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return Dialog(
            child: FittedBox(
          child: TimePickerDialog(
            initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
          ),
        ));
      },
    );
    if (d != null) {
      DateTime date = now.copyWith(hour: d.hour, minute: d.minute);
      if (date.isBefore(now)) date = date.add(const Duration(days: 1));
      return date;
    }
    return null;
  }

  void _scheduleReminder(DateTime time) {
    ref.read(notificationsProvider.notifier).schedule(
          todo: widget.todo,
          time: time,
          message: text,
        );
    Navigator.of(context).pop();
  }
}

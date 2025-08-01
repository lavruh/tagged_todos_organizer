import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/notifications/domain/reminder.dart';

class ReminderWidget extends StatelessWidget {
  const ReminderWidget({super.key, required this.item, required this.onDelete});
  final Reminder item;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd MMM\t HH:mm').format(item.time)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            Text(item.title, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

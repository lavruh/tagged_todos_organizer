import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';

class LogEntryWidget extends StatelessWidget {
  const LogEntryWidget({Key? key, required this.entry}) : super(key: key);

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          '${entry.title} is ${entry.action.name} @ ${DateFormat('y-MM-dd\t hh:mm:ss').format(entry.date)}'),
    );
  }
}

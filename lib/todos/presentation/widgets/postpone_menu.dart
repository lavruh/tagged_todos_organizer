import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';

class PostponeMenuWidget extends ConsumerWidget {
  const PostponeMenuWidget({
    super.key,
    required this.item,
  });
  final ToDo item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Postpone till...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
              onPressed: () => _postpone(ref, context, DateTime.now(), days: 1),
              child: const Text('Tomorrow')),
          TextButton(
              onPressed: () => _postpone(ref, context, DateTime.now(), days: 0),
              child: const Text('Today')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 3),
              child: const Text('3 days')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 7),
              child: const Text('Next week')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 42),
              child: const Text('6 weeks')),
          TextButton(
              onPressed: () => _setDateDialog(ref, context),
              child: const Text('Specify date')),
          TextButton(
              onPressed: () => _clearDate(ref, context),
              child: const Text('Clear Date')),
        ],
      ),
    );
  }

  _postponeDays(WidgetRef ref, BuildContext context, int days) {
    final date = item.date ?? DateTime.now();
    _postpone(ref, context, date, days: days);
  }

  _postpone(
    WidgetRef ref,
    BuildContext context,
    DateTime date, {
    int days = 0,
  }) {
    final newDate = date.add(Duration(days: days));
    Navigator.of(context).pop(newDate);
  }

  _clearDate(WidgetRef ref, BuildContext context) =>
      Navigator.of(context).pop(null);

  _setDateDialog(WidgetRef ref, BuildContext context) async {
    final date = await showDialog<DateTime>(
        context: context,
        builder: (context) => DatePickerDialog(
            initialDate: item.date ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 3)));
    if (date != null && context.mounted) {
      _postpone(ref, context, date);
    }
  }
}

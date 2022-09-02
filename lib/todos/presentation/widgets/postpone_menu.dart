import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

class PostponeMenuWidget extends ConsumerWidget {
  const PostponeMenuWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
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
            style: Theme.of(context).textTheme.headline5,
          ),
          TextButton(
              onPressed: () => _postponeTillTomorrow(ref, context),
              child: const Text('Tomorrow')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 3),
              child: const Text('3 days')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 7),
              child: const Text('Next week')),
          TextButton(
              onPressed: () => _postponeDays(ref, context, 42),
              child: const Text('6 weeks')),
        ],
      ),
    );
  }

  _postponeTillTomorrow(WidgetRef ref, BuildContext context) {
    final now = DateTime.now();
    ref.read(todosProvider.notifier).updateTodo(
          item: item.copyWith(
              date: DateTime.fromMillisecondsSinceEpoch(
                  now.millisecondsSinceEpoch + 86400000)),
        );
    Navigator.of(context).pop();
  }

  _postponeDays(WidgetRef ref, BuildContext context, int days) {
    final date = item.date ?? DateTime.now();
    ref.read(todosProvider.notifier).updateTodo(
          item: item.copyWith(
              date: DateTime.fromMillisecondsSinceEpoch(
                  date.millisecondsSinceEpoch + 86400000 * days)),
        );
    Navigator.of(context).pop();
  }
}

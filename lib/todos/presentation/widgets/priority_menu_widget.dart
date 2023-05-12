import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';

class PriorityMenuWidget extends ConsumerWidget {
  const PriorityMenuWidget({
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
            'Set priority...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            label: 'Priority',
            value: item.priority.toDouble(),
            onChanged: (val) {
              ref
                  .read(todosProvider.notifier)
                  .updateTodo(item: item.copyWith(priority: val.round()));
              Navigator.of(context).pop();
            },
            min: 0,
            max: 10,
            divisions: 10,
            secondaryTrackValue: 1,
          )
        ],
      ),
    );
  }
}

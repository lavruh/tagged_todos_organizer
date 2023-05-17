import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_slider_widget.dart';

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
          PrioritySliderWidget(
            initValue: item.priority,
            setValue: (int val) {
              ref
                  .read(todosProvider.notifier)
                  .updateTodo(item: item.copyWith(priority: val.round()));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

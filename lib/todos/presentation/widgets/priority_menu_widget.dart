import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_slider_widget.dart';

class PriorityMenuWidget extends ConsumerStatefulWidget {
  const PriorityMenuWidget({
    super.key,
    required this.item,
    this.onConfirm,
  });

  final ToDo item;
  final Function(ToDo)? onConfirm;

  @override
  ConsumerState<PriorityMenuWidget> createState() => _PriorityMenuWidgetState();
}

class _PriorityMenuWidgetState extends ConsumerState<PriorityMenuWidget> {
  late ToDo item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              PrioritySliderWidget(
                initValue: item.priority,
                title: "Priority",
                setValue: (int val) {
                  setState(() => item = item.copyWith(priority: val.round()));
                },
              ),
              PrioritySliderWidget(
                initValue: item.urgency,
                title: "Urgency",
                setValue: (int val) {
                  setState(() => item = item.copyWith(urgency: val));
                },
              ),
            ],
          ),
          SizedBox.square(
            dimension: 40,
            child: AnimatedCrossFade(
              firstChild: Container(),
              secondChild: IconButton(
                  onPressed: () {
                    final f = widget.onConfirm;
                    if (f != null) {
                      f(item);
                    } else {
                      _confirm();
                    }
                  },
                  icon: const Icon(Icons.check)),
              crossFadeState: widget.item == item
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }

  void _confirm() {
    ref.read(todosProvider.notifier).updateTodo(item: item);
  }
}

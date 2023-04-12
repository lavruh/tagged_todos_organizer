import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/tree_controller_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';

class TodoTreeWidget extends ConsumerWidget {
  const TodoTreeWidget({Key? key, this.onTap}) : super(key: key);

  final Function(ToDo t)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeController = ref.watch(treeControllerProvider);
    return AnimatedTreeView(
        treeController: treeController,
        nodeBuilder: (_, TreeEntry<ToDo> entry) {
          return TreeIndentation(
            entry: entry,
            child: Row(
              children: [
                Flexible(
                  child: TodoPrevWidget(
                    item: entry.node,
                    onTapTitle: onTap != null ? () => onTap!(entry.node) : null,
                    onTapSubTaskCount: () {
                      treeController.toggleExpansion(entry.node);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class DayViewItemWidget extends StatelessWidget {
  const DayViewItemWidget({
    super.key,
    required this.item,
    required this.onUpdate,
    this.onRemove,
    this.onCreatePermanent,
    this.onOpenInEditor,
    required this.isTmpTodo,
  });
  final ToDo item;
  final bool isTmpTodo;
  final Function(ToDo) onUpdate;
  final Function(ToDo)? onRemove;
  final Future Function(ToDo, Function openEditor)? onCreatePermanent;
  final Function(ToDo, Function openEditor)? onOpenInEditor;

  @override
  Widget build(BuildContext context) {
    final suffixPanel = isTmpTodo
        ? Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                onPressed: () {
                  onCreatePermanent?.call(
                      item, () => context.go('/TodoEditorScreen'));
                },
                tooltip: "Create permanent",
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () => onRemove?.call(item),
                tooltip: "Delete",
                icon: const Icon(Icons.delete_forever))
          ])
        : IconButton(
            onPressed: () => onOpenInEditor?.call(
                item, () => context.go('/TodoEditorScreen')),
            tooltip: "Open editor",
            icon: const Icon(Icons.note_alt));

    return ListTile(
      title: TextFormField(
        initialValue: item.title,
        decoration: InputDecoration(suffix: suffixPanel),
        onFieldSubmitted: (v) => onUpdate(item.copyWith(title: v)),
      ),
      subtitle: Row(
        children: [
          SizedBox(
            width: 50,
            child: TextButton(
              onPressed: () {},
              child: Text(item.priority.toString()),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration:
                  const BoxDecoration(border: Border(left: BorderSide())),
              child: TextFieldWithConfirm(
                text: item.description,
                border: InputBorder.none,
                onConfirm: (v) => onUpdate(item.copyWith(description: v)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

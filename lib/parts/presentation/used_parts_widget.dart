import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_part_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';

class UsedPartsWidget extends ConsumerWidget {
  const UsedPartsWidget({Key? key, required this.update}) : super(key: key);
  final Function(List<UsedPart>) update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(todoEditorProvider)?.usedParts ?? [];
    return Card(
      child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Used parts (${items.length}) :'),
              IconButton(
                  onPressed: () => _addPart(ref), icon: const Icon(Icons.add)),
            ],
          ),
          children: [
            ...items.map((e) => UsedPartWidget(
                  item: e,
                  update: (newVal) {
                    final index = items.indexOf(e);
                    items.removeAt(index);
                    items.insert(index, newVal);
                    update(items);
                  },
                  delete: () {
                    final index = items.indexOf(e);
                    items.removeAt(index);
                    update(items);
                  },
                ))
          ]),
    );
  }

  void _addPart(WidgetRef ref) {
    final todo = ref.watch(todoEditorProvider);
    ref.read(todoEditorProvider.notifier).setTodo(todo!.copyWith(
          usedParts: [...todo.usedParts, UsedPart.empty()],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_editor_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_part_widget.dart';

class UsedPartsWidget extends ConsumerWidget {
  const UsedPartsWidget({Key? key, required this.update}) : super(key: key);
  final Function(List<UsedPart>) update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(partsEditorProvider);
    return Card(
      child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Used parts (${items.length}) :'),
              IconButton(
                  onPressed: () => _addPart(ref), icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () => _addPartFromPhotoNumber(ref, context),
                  icon: const Icon(Icons.add_a_photo))
            ],
          ),
          children: [
            ...items.map((e) => UsedPartWidget(
                  item: e,
                  update: (newVal) => ref
                      .read(partsEditorProvider.notifier)
                      .updatePart(newVal, items.indexOf(e)),
                  updateMaximoNo: (part) => ref
                      .read(partsEditorProvider.notifier)
                      .updatePartWithMaximoNo(
                          part: part, index: items.indexOf(e)),
                  delete: () => ref
                      .read(partsEditorProvider.notifier)
                      .delete(index: items.indexOf(e)),
                ))
          ]),
    );
  }

  void _addPart(WidgetRef ref) {
    ref.read(partsEditorProvider.notifier).addPart();
  }

  _addPartFromPhotoNumber(WidgetRef ref, BuildContext context) async {
    ref.read(partsEditorProvider.notifier).addPartFromPhotoNumber(context);
  }
}

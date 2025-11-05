import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_editor_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_part_widget.dart';

class UsedPartsWidget extends ConsumerWidget {
  const UsedPartsWidget({super.key, required this.update});
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
              Expanded(child: Container()),
              IconButton(
                  onPressed: () => _addPart(ref), icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () =>
                      context.go('/TodoEditorScreen/UsedPartsEditScreen'),
                  icon: const Icon(Icons.table_chart_outlined)),
              IconButton(
                  onPressed: () => _addPartFromPhotoNumber(ref, context),
                  icon: const Icon(Icons.add_a_photo))
            ],
          ),
          children: [
            ...items.map((e) {
              final idx = items.indexOf(e);
              if (idx == -1) return Container();
              final state = ref.read(partsEditorProvider.notifier);
              return UsedPartWidget(
                item: e,
                update: (v) => state.updatePart(v, idx),
                updateMaximoNo: (part) =>
                    state.updatePartWithMaximoNo(part: part, index: idx),
                updateCatalogNo: (p) =>
                    state.updatePartWithCatalogNo(part: p, index: idx),
                delete: () => state.delete(index: idx),
              );
            })
          ]),
    );
  }

  void _addPart(WidgetRef ref) {
    ref.read(partsEditorProvider.notifier).addPart();
  }

  Future<void> _addPartFromPhotoNumber(WidgetRef ref, BuildContext context) async {
    context.go('/TodoEditorScreen/AddUsedPartScreen');
  }
}

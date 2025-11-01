import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';

final partsEditorProvider =
    StateNotifierProvider<PartsEditorNotifier, List<UsedPart>>(
        (ref) => PartsEditorNotifier(ref));

class PartsEditorNotifier extends StateNotifier<List<UsedPart>> {
  Ref ref;

  PartsEditorNotifier(this.ref)
      : super(ref.watch(todoEditorProvider)?.usedParts ?? []);

  void updatePart(UsedPart part, int index) {
    var tmp = state;
    tmp.removeAt(index);
    tmp.insert(index, part);
    state = [...tmp];
    ref.read(todoEditorProvider.notifier).updateTodoState(usedParts: state);
  }

  void addPart() {
    final newPart = UsedPart.empty();
    if (state.any((p) => p.hashCode == newPart.hashCode)) return;
    state = [...state, UsedPart.empty()];
    ref.read(todoEditorProvider.notifier).updateTodoState(usedParts: state);
  }

  Future<void> addPartFromPhotoNumber(String? reading) async {
    if (reading != null) {
      final p = await ref.read(partsInfoProvider).getPart(reading);
      final usedPart = UsedPart.fromPart(part: p, qty: 0);
      addUsedPart(usedPart);
    }
  }

  void addUsedPart(UsedPart part) {
    ref.read(todoEditorProvider.notifier).updateTodoState(
      usedParts: [...state, part],
    );
  }

  void delete({required int index}) {
    state.removeAt(index);
    ref.read(todoEditorProvider.notifier).updateTodoState(usedParts: state);
  }

  void updatePartWithMaximoNo(
      {required UsedPart part, required int index}) async {
    final p = await ref.read(partsInfoProvider).getPart(part.maximoNumber);
    _updateUsedPartFromDb(part, p, index);
  }

  void updatePartWithCatalogNo(
      {required UsedPart part, required int index}) async {
    final p =
        await ref.read(partsInfoProvider).getPartByCatalogNo(part.catalogNo);
    _updateUsedPartFromDb(part, p, index);
  }

  void _updateUsedPartFromDb(UsedPart part, Part partFromDb, int index) {
    final item = partFromDb.name.isEmpty
        ? part
        : UsedPart.fromPart(part: partFromDb, qty: part.pieces);
    updatePart(item, index);
  }
}

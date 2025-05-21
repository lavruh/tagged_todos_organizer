import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  updatePart(UsedPart part, int index) {
    state.removeAt(index);
    state.insert(index, part);
    ref.read(todoEditorProvider.notifier).updateTodoState(usedParts: state);
  }

  addPart() {
    final todo = ref.watch(todoEditorProvider);
    ref.read(todoEditorProvider.notifier).setTodo(todo!.copyWith(
          usedParts: [...todo.usedParts, UsedPart.empty()],
        ));
  }

  addPartFromPhotoNumber(String? reading) async {
    if (reading != null) {
      final p = await ref.read(partsInfoProvider).getPart(reading);
      final usedPart = UsedPart.fromPart(part: p, qty: 0);
      addUsedPart(usedPart);
    }
  }

  addUsedPart(UsedPart part) {
    ref.read(todoEditorProvider.notifier).updateTodoState(
      usedParts: [...state, part],
    );
  }

  void delete({required int index}) {
    state.removeAt(index);
    ref.read(todoEditorProvider.notifier).updateTodoState(usedParts: state);
  }

  updatePartWithMaximoNo({required UsedPart part, required int index}) async {
    final p = await ref.read(partsInfoProvider).getPart(part.maximoNumber);
    UsedPart newPart = part;
    if (p.name != "") {
      newPart = part.copyWith(name: p.name, bin: p.bin);
    }
    updatePart(newPart, index);
  }
}

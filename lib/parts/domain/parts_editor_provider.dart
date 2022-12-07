import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:photo_data_picker/domain/camera_state.dart';
import 'package:photo_data_picker/domain/camera_state_device.dart';
import 'package:photo_data_picker/domain/recognizer.dart';
import 'package:photo_data_picker/ui/screen/camera_screen.dart';

final partsEditorProvider =
    StateNotifierProvider<PartsEditorNotifier, List<UsedPart>>(
        (ref) => PartsEditorNotifier(ref));

class PartsEditorNotifier extends StateNotifier<List<UsedPart>> {
  StateNotifierProviderRef ref;

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

  addPartFromPhotoNumber(BuildContext context) async {
    final reading = await _getCameraReading(context);

    if (reading != null) {
      final todo = ref.watch(todoEditorProvider);

      final p = await ref.read(partsInfoProvider).getPart(reading);

      ref.read(todoEditorProvider.notifier).setTodo(todo!.copyWith(
            usedParts: [
              ...todo.usedParts,
              UsedPart(
                  maximoNumber: p.maximoNo, name: p.name, bin: p.bin, pieces: 0)
            ],
          ));
    }
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

Future<String?> _getCameraReading(BuildContext context) async {
  final navigator = Navigator.of(context);
  if (Platform.isAndroid) {
    final cams = await availableCameras();
    Get.put(Recognizer());
    Get.put<CameraState>(CameraStateDevice(
      flashMode: FlashMode.off,
      cameras: cams,
      tmpFile: File('/storage/emulated/0/TagsTodosOrganizer/maximoNo.jpg'),
    ));

    return await navigator.push(MaterialPageRoute(
      builder: (context) => CameraScreen(),
    ));
  }
  return null;
}

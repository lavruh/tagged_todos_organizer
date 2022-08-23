import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

final imagesViewProvider = StateNotifierProvider<ImagesViewNotifier, String?>(
    (ref) => ImagesViewNotifier());

class ImagesViewNotifier extends StateNotifier<String?> {
  ImagesViewNotifier() : super(null);
  final editor = Get.put(DesignationOnImageState());
  List<String> filesToPreview = [];
  int currentImageIndex = 0;

  openImage(String path) async {
    editor.loadImage(File(path));
    final dir = Directory(p.dirname(path));
    filesToPreview.clear();
    for (final f in dir.listSync()) {
      final ext = p.extension(f.path);
      if (ext == '.jpg' || ext == '.jpeg') {
        filesToPreview.add(f.path);
      }
    }
    state = path;
  }

  openNextImage({required bool increaseIndex}) async {
    bool canGoNext = false;
    editor.hasToSavePromt(onConfirmCallback: () async {
      await editor.saveImage();
      canGoNext = true;
    }, onNoCallback: () {
      canGoNext = true;
    });
    if (!canGoNext) {
      return;
    }
    if (increaseIndex) {
      if (currentImageIndex + 1 < filesToPreview.length) {
        currentImageIndex++;
      } else {
        currentImageIndex = 0;
      }
    } else {
      if (currentImageIndex - 1 >= 0) {
        currentImageIndex--;
      } else {
        currentImageIndex = filesToPreview.length - 1;
      }
    }

    editor.loadImage(File(filesToPreview[currentImageIndex]));
  }
}

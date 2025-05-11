import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  StreamSubscription<FileSystemEvent>? _eventSubscription;
  BuildContext? context;

  openImage(String path) async {
    final file = File(path);
    editor.open(file);
    final dir = Directory(p.dirname(path));
    final eventStream = dir.watch();
    _eventSubscription = eventStream.listen(_updateDueToFSEvent);
    filesToPreview.clear();
    for (final f in dir.listSync()) {
      final ext = p.extension(f.path);
      if (ext == '.jpg' || ext == '.jpeg' || ext == '.notes') {
        filesToPreview.add(f.path);
      }
    }
    state = path;
  }

  openNextImage({required bool increaseIndex}) async {
    bool canGoNext = await saveImageRequest();
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
    final nextFile = File(filesToPreview[currentImageIndex]);
    editor.open(nextFile);
    state = nextFile.path;
  }

  Future<bool> saveImageRequest() async {
    bool result = false;
    await editor.hasToSaveDialog(onConfirmCallback: () async {
      await editor.saveZip();
      result = true;
    }, onNoCallback: () {
      result = true;
    });
    return result;
  }

  _updateDueToFSEvent(FileSystemEvent event) {
    if (event is FileSystemMoveEvent) {
      final path = event.destination;
      if (path != null) openImage(path);
    }
    if (event is FileSystemDeleteEvent) close();
  }

  close() {
    _eventSubscription?.cancel();
    context?.pop();
    context = null;
  }
}

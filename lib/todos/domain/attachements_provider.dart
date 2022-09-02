import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:process_run/shell.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

final attachementsProvider =
    StateNotifierProvider<AttachementsNotifier, List<String>>(
        (ref) => AttachementsNotifier(ref));

class AttachementsNotifier extends StateNotifier<List<String>> {
  AttachementsNotifier(this.ref) : super([]);
  String? path;
  late Directory root;
  StateNotifierProviderRef ref;

  load({List<String>? attachs, required String attachementsFolder}) {
    if (attachementsFolder.isNotEmpty) {
      final dir = Directory(p.join(getAppFolderPath(), attachementsFolder));
      if (dir.existsSync()) {
        path = dir.path;
      }
    } else {
      path = null;
    }
    updateAttachements();
  }

  updateAttachements() {
    if (path != null) {
      final dir = Directory(path!);
      List<String> files = [];
      for (final file in dir.listSync()) {
        if (file is File) {
          files.add(file.path);
        }
      }
      state = files;
    } else {
      state = [];
    }
  }

  void addPhoto() async {
    if (path != null) {
      if (Platform.isAndroid) {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        final name = DateFormat('y-M-d_hh_mm_ss').format(DateTime.now());
        final filePath = p.join(path!, 'img_$name.jpg');
        photo?.saveTo(filePath);
        _updateState(filePath);
      }
    } else {
      showNotification();
    }
  }

  void attachFile() async {
    if (path != null) {
      final picker = await FilePicker.platform.pickFiles();
      if (picker != null && picker.paths.first != null) {
        final filePath = picker.paths.first!;
        final name = p.basename(filePath);
        final newPath = p.join(path!, name);
        await File(filePath).copy(newPath);
        _updateState(newPath);
      }
    } else {
      showNotification();
    }
  }

  void openFolder() {
    if (path != null) {
      OpenFilex.open(path);
    }
  }

  void _updateState(String filePath) {
    state = [...state, filePath];
  }

  void showNotification() {
    ref
        .read(snackbarProvider.notifier)
        .show('Can not add attachement. Save item first.');
  }

  void openFile({required String file}) {
    if (Platform.isLinux) {
      final shell = Shell();
      shell.run("xdg-open '$file'");
    }
    if (Platform.isAndroid) {
      OpenFilex.open(file);
    }
  }

  String getParentDirPath({String? parentId}) {
    final root = Directory(ref.read(appPathProvider));
    if (parentId == null) {
      return p.join(root.path, 'todos');
    }
    for (final item in root.listSync(recursive: true)) {
      if (p.basename(item.path) == parentId) {
        return item.path;
      }
    }
    throw (Exception('No item with id $parentId found'));
  }
}

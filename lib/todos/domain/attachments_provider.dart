import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

final attachmentsProvider =
    StateNotifierProvider<AttachmentsNotifier, List<String>>(
        (ref) => AttachmentsNotifier(ref));

class AttachmentsNotifier extends StateNotifier<List<String>> {
  AttachmentsNotifier(this.ref) : super([]);
  String? path;
  late Directory root;
  Ref ref;

  bool get isReady => path != null;

  String? manage({
    required String id,
    bool createDir = false,
    required String attachmentsDirPath,
    String? parentId,
  }) {
    try {
      setPath(attachmentsFolder: attachmentsDirPath);
    } on Exception {
      String newPath = '';
      try {
        newPath = getParentDirPath(parentId: id);
        setPath(attachmentsFolder: newPath);
      } on Exception {
        newPath = p.join(getParentDirPath(parentId: parentId), id);
        if (createDir) {
          Directory(newPath).createSync(recursive: true);
          setPath(attachmentsFolder: newPath);
        } else {
          path = null;
          updateAttachments();
        }
      }
      updateAttachments();
      return newPath;
    }
    updateAttachments();
    return null;
  }

  resetState() => path = null;

  setPath({required String attachmentsFolder}) {
    if (attachmentsFolder.isEmpty ||
        !Directory(attachmentsFolder).existsSync()) {
      throw Exception('Directory [$attachmentsFolder] does not exist');
    }
    path = attachmentsFolder;
  }

  updateAttachments() {
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
      OpenFilex.open(path!);
    }
  }

  void _updateState(String filePath) {
    state = [...state, filePath];
  }

  void showNotification() {
    ref
        .read(snackbarProvider.notifier)
        .show('Can not add attachment. Save item first.');
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
    throw (Exception(
        'No item with id <$parentId>[${parentId.runtimeType}] found.'));
  }

  Directory moveAttachments({required String oldPath, String? newParent}) {
    final root = ref.read(appPathProvider);
    final path = getParentDirPath(parentId: newParent);
    final oldDir = Directory(p.join(root, oldPath));
    if (oldPath.isNotEmpty && oldDir.existsSync()) {
      final dirName = p.basenameWithoutExtension(oldPath);
      final newDirPath = p.join(path, dirName);
      final newDir = Directory(newDirPath);
      _copyDirectory(oldDir, newDir);
      oldDir.deleteSync(recursive: true);
      return newDir;
    } else {
      throw Exception('Attachment folder does not exist $oldPath');
    }
  }

  void _copyDirectory(Directory source, Directory destination) {
    destination.createSync(recursive: true);
    source.listSync().forEach((entity) {
      final targetPath = p.join(destination.path, p.basename(entity.path));
      if (entity is File) {
        entity.copySync(targetPath);
      }
      if (entity is Directory) {
        Directory newSubdir = Directory(targetPath);
        newSubdir.createSync(recursive: true);
        _copyDirectory(entity, newSubdir);
      }
    });
  }

  void deleteAttachmentFile({required String path}) {
    File(path).deleteSync();
    updateAttachments();
  }

  void renameAttachmentFile(
      {required String filePath, required String newName}) {
    final f = File(filePath);
    if (f.existsSync()) {
      f.renameSync(p.join(p.dirname(filePath), newName));
      updateAttachments();
    }
  }

  void pasteFromBuffer() async {
    final todoDirPath = path;
    final root = ref.read(appPathProvider);
    final bufferDir = Directory(p.join(root, 'buffer'));
    bufferDir.createSync(recursive: true);
    if (bufferDir.existsSync()) {
      final files = bufferDir.listSync(recursive: true);
      for (final file in files) {
        if (file is File) {
          if (todoDirPath != null) {
            final name = p.basename(file.path);
            await file.copy(p.join(todoDirPath, name));
            file.delete();
          }
        }
      }
    }
    updateAttachments();
  }
}

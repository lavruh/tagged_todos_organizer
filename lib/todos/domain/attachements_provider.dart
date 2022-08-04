import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

final attachementsProvider =
    StateNotifierProvider<AttachementsNotifier, List<String>>(
        (ref) => AttachementsNotifier(ref));

class AttachementsNotifier extends StateNotifier<List<String>> {
  AttachementsNotifier(this.ref) : super([]);
  String? path;
  late Directory root;
  StateNotifierProviderRef ref;

  load({required List<String> attachs, required String attachementsFolder}) {
    if (attachementsFolder.isNotEmpty) {
      final dir = Directory(p.normalize(attachementsFolder));
      if (dir.existsSync()) {
        path = dir.path;
      }
    } else {
      path = null;
    }
    state = attachs;
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
}
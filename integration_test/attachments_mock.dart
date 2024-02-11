import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';

class AttachmentsNotifierMock extends StateNotifier<List<String>>
    implements AttachmentsNotifier {
  AttachmentsNotifierMock(this.ref) : super([]);
  @override
  String? path;
  @override
  late Directory root;
  @override
  StateNotifierProviderRef ref;

  @override
  String? manage({
    required String id,
    bool createDir = false,
    required String attachmentsDirPath,
    String? parentId,
  }) {
    return '';
  }

  @override
  resetState() => path = null;

  @override
  setPath({required String attachmentsFolder}) {
    path = attachmentsFolder;
  }

  @override
  updateAttachments() {}

  @override
  void addPhoto() async {}

  @override
  void attachFile() async {}

  @override
  void openFolder() {}

  @override
  void showNotification() {}

  @override
  void openFile({required String file}) {}

  @override
  String getParentDirPath({String? parentId}) {
    return parentId ?? '';
  }

  @override
  Directory moveAttachments({required String oldPath, String? newParent}) {
    return Directory('');
  }
}

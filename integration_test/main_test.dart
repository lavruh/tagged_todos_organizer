import 'package:flutter_test/flutter_test.dart';

import 'duplicate_todo_test.dart';
import 'tmp_todo_test.dart';
import 'todo_editor_test.dart';
import 'log_service_test.dart';
import 'postpone_menu_test.dart';
import 'tags_editor.dart';
import 'tags_selector_test.dart';
import 'todos_filter_test.dart';

void main() async {
  testWidgets('duplicate todo test', duplicateTodoTest);
  testWidgets('tags editor test', tagsEditorTest);
  testWidgets('tags selector test', tagsSelectorTest);
  testWidgets('todo editor test', todoEditorTest);
  testWidgets('todo filter test', todoFilterTest);
  testWidgets('postpone todo test', postponeTodoTest);
  testWidgets('log service test', logServiceTest);
  testWidgets('tmp todo test', tmpTodoTest);
}

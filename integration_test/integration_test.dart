import 'package:flutter_test/flutter_test.dart';

import '../test/integration_test/todo_editor_test.dart';
import 'tags_editor.dart';
import 'tags_selector_test.dart';
import 'todos_filter_test.dart';

void main() async {
  testWidgets('tags editor test', tagsEditorTest);
  testWidgets('tags selector test', tagsSelectorTest);
  testWidgets('tags selector test', todoEditorTest);
  testWidgets('tags selector test', todoFilterTest);
}

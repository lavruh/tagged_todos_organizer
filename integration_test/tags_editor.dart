import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import './tags_editor.mocks.dart';

/* 
open app todos screen
> find add icon
> tags editor icon

click on menu button
> open menu
> find tags editor text
> find text 'Update parts db'

click text 'Tags Editor'
> find icon add
> find tag with text and color
> find text 'Search'

click icon add
> find extra tag without text

click new tag
> find text 'Tag name'
> find icon color

edit tag name
> find icon check

click icon check
> find tag with text

click text 'Search' enter text
> find only one tag with text
*/

@GenerateMocks([SembastDbService])
Future<void> tagsEditorTest(WidgetTester tester) async {
  final tagsDb = MockSembastDbService();
  final existedTag = Tag.empty().copyWith(name: 'tag1', color: 0);

  when(tagsDb.getAll(table: 'tags'))
      .thenAnswer((realInvocation) => Stream.value(existedTag.toMap()));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider.overrideWith((ref) => '/home/lavruh/Documents/TaggedTodosOrganizer'),
      tagsDbProvider.overrideWith((ref) => tagsDb),
    ],
    child: const MyApp(),
  ));

  await tester.pump();

  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('Tags Editor'), findsOneWidget);
  expect(find.text('Update parts db'), findsOneWidget);

  await tester.tap(find.text('Tags Editor'));
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.add), findsOneWidget);
  final tagWidget = find.widgetWithText(InputChip, existedTag.name);
  expect(tagWidget, findsOneWidget);
  expect(tester.widget<InputChip>(tagWidget).backgroundColor?.value,
      existedTag.color);
  expect(find.text('Search'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  final tagWidgets = find.byType(TagWidget);
  expect(tagWidgets, findsNWidgets(2));

  await tester.tap(tagWidgets.last);
  await tester.pumpAndSettle();
  expect(find.text('Tag name'), findsOneWidget);

  final newTag = Tag.empty().copyWith(name: 'newTag', color: Colors.red.value);
  final editorNameField = find.widgetWithText(TextField, 'Tag name');
  await tester.enterText(editorNameField, newTag.name);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.check), findsOneWidget);
  await tester.tap(find.byIcon(Icons.check));
  await tester.pumpAndSettle();
  expect(find.widgetWithText(InputChip, newTag.name), findsOneWidget);

  await tester.enterText(
      find.widgetWithText(TextField, 'Search'), existedTag.name);
  await tester.pumpAndSettle();
  expect(find.widgetWithText(InputChip, newTag.name), findsNothing);
  expect(find.widgetWithText(InputChip, existedTag.name), findsOneWidget);

  await tester.pageBack();
}

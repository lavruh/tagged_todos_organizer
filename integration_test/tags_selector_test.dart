import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'tags_selector_test.mocks.dart';

/*
Load app 
    check tags in prev widget

1.
Tap on TODO name 
    open todo editor
    find preset tags 

2.
Tap tags area container
    find preset tags
    fing 'Search'
    fing 'Confirm'
    find selected tags

3.
Tap on selected tag
    check that tag deselected

4.
Enter tagToSelect tag name to search 
    find one tag 

5.
Tap on another tagToSelect
    find confirm tagToSelect is selected

6.
Tap confirm
    find tags except deselected

*/

@GenerateMocks([IDbService])
Future<void> tagsSelectorTest(WidgetTester tester) async {
  final db = MockIDbService();
  final tags = List<Tag>.generate(
      5,
      (i) => Tag.empty().copyWith(
          name: "tag_$i", color: 100 * i, id: UniqueId(id: 'tag_$i')));
  final selectedTags = [tags[0], tags[2]];
  final tagToSelect = tags[1];
  List<ToDo> todos = [
    ToDo.empty().copyWith(
      title: "Todo",
      description: "line1 \n line2",
      tags: selectedTags.map<UniqueId>((e) => e.id).toList(),
      date: DateTime(2023),
    ),
  ];

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags')).thenAnswer(
      (realInvocation) => Stream.fromIterable(tags.map((e) => e.toMap())));
  when(db.getAll(table: 'todos')).thenAnswer(
      (realInvocation) => Stream.fromIterable(todos.map((e) => e.toMap())));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      tagsDbProvider.overrideWith((ref) => db),
      todosDbProvider.overrideWith((ref) => db),
    ],
    child: const MyApp(),
  ));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  expect(find.byType(TodoPrevWidget), findsNWidgets(todos.length));
  expect(find.byType(InputChip), findsNWidgets(todos.first.tags.length));

// 1.
  await tester.tap(find.text(todos.first.title));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  final tagsPrevWidget = find.byType(TagsPreviewWidget);
  expect(find.descendant(of: tagsPrevWidget, matching: find.byType(InputChip)),
      findsNWidgets(todos.first.tags.length));
  expect(
      find.descendant(
          of: tagsPrevWidget, matching: find.text(selectedTags.first.name)),
      findsOneWidget);
  expect(
      find.descendant(
          of: tagsPrevWidget, matching: find.text(selectedTags.last.name)),
      findsOneWidget);

// 2.
  await tester.tap(tagsPrevWidget);
  await tester.pump(const Duration(seconds: 1));
  expect(find.text('Confirm'), findsOneWidget);
  expect(find.text('Search'), findsOneWidget);
  final tagSelectWidget = find.byType(TagSelectWidget);
  final tagWidgetsList1 = tester.widgetList<TagWidget>(
      find.descendant(of: tagSelectWidget, matching: find.byType(TagWidget)));
  expect(
      tagWidgetsList1
          .any((e) => e.selected && e.e.name == selectedTags.first.name),
      true);
  expect(
      tagWidgetsList1
          .any((e) => e.selected && e.e.name == selectedTags.last.name),
      true);

//  3.
  final tagToDeselect = tagWidgetsList1.firstWhere((e) => e.selected == true);
  final widgetTagToDeselect = find.byWidget(tagToDeselect);
  await tester.tap(widgetTagToDeselect);
  await tester.pump(const Duration(seconds: 1));
  expect(
      tester
          .widget<TagWidget>(
              find.widgetWithText(TagWidget, tagToDeselect.e.name))
          .selected,
      false);
  expect(find.descendant(of: tagsPrevWidget, matching: find.byType(InputChip)),
      findsNWidgets(1));

//  4.
  await tester.enterText(
      find.widgetWithText(TextField, 'Search'), tagToSelect.name);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 10));
  final widgetTagToSelect =
      find.descendant(of: tagSelectWidget, matching: find.byType(InputChip));
  expect(widgetTagToSelect, findsOneWidget);

//  5.
  await tester.tap(widgetTagToSelect);
  await tester.pump(const Duration(seconds: 1));
  await tester.enterText(find.widgetWithText(TextField, 'Search'), '');
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  final reSelectedTags = tester.widgetList<TagWidget>(find.descendant(
      of: tagSelectWidget,
      matching: find.widgetWithText(TagWidget, tagToSelect.name)));
  expect(
      reSelectedTags.any(
          (element) => element.e.name == tagToSelect.name && element.selected),
      true);
// 6.
  await tester.tap(find.text('Confirm'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.descendant(of: tagsPrevWidget, matching: find.byType(TagWidget)),
      findsNWidgets(2));

  await tester.pageBack();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 10));
}

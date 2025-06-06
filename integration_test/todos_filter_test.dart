import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

import 'todo_editor_test.mocks.dart';

/*
Load app only todos with date now and less are visible
show future todos filter
show done todos filter
show sub tasks filter
filter by tag
filter by date
search field
 */

main() async {
  testWidgets('todo filter test', todoFilterTest);
}

Future<void> todoFilterTest(WidgetTester tester) async {
  final db = MockIDbService();
  final now = DateTime.now();
  final tags = List<Tag>.generate(4,
      (i) => Tag.empty().copyWith(id: UniqueId(id: "tag_$i"), name: "tag_$i"));
  final todoWithTags = ToDo.empty().copyWith(
      title: "Todo_1",
      id: UniqueId(id: "id_1"),
      tags: [tags.first.id, tags.last.id]);
  final todoWithDate = ToDo.empty()
      .copyWith(title: "Todo_2", id: UniqueId(id: "id_2"), date: now);
  final todoFuture = todoWithDate.copyWith(
      title: "Todo_future",
      id: UniqueId(id: "id_future"),
      date: DateTime(now.year + 1));
  final todoDone = todoWithDate.copyWith(
      title: "Todo_done", id: UniqueId(id: "id_done"), done: true);
  final subTodo = todoWithTags.copyWith(
      title: "SubTodo",
      id: UniqueId(id: "id_subtodo"),
      parentId: todoWithTags.id);
  List<ToDo> todos = [
    todoWithTags,
    todoWithDate,
    todoFuture,
    todoDone,
    subTodo
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
  await tester.pumpAndSettle();
  expect(find.text(todoWithDate.title), findsOneWidget);
  expect(find.text(todoWithTags.title), findsOneWidget);
  expect(find.text(todoDone.title), findsNothing);
  expect(find.text(todoFuture.title), findsNothing);
  expect(find.text(subTodo.title), findsNothing);

  await tester.tap(find.byIcon(Icons.filter_alt_outlined));
  await tester.pumpAndSettle();
  expect(find.textContaining('Show future'), findsOneWidget);
  expect(find.byIcon(Icons.data_exploration_outlined), findsOneWidget);
  await tester.pumpAndSettle();

  //show future todos filter
  await tester.tap(find.textContaining('Show future'));
  await tester.pumpAndSettle();
  expect(find.text(todoFuture.title), findsOneWidget);
  expect(find.byIcon(Icons.data_exploration), findsOneWidget);

  //show done todos filter
  expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
  await tester.tap(find.textContaining('Show done'));
  await tester.pumpAndSettle();
  expect(find.text(todoDone.title), findsOneWidget);
  expect(find.byIcon(Icons.check_box), findsOneWidget);

  // filter by date
  expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
  await tester.tap(find.textContaining('Filter by date'));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Start Date'),
      DateFormat('MM/dd/yyyy').format(now));
  await tester.enterText(
      find.widgetWithText(TextField, 'End Date'),
      DateFormat('MM/dd/yyyy')
          .format(DateTime(now.year, now.month, now.day + 1)));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('OK'));
  await tester.pumpAndSettle();
  expect(find.text(todoWithDate.title), findsOneWidget);
  expect(find.byIcon(Icons.calendar_month), findsOneWidget);
  await tester.tap(find.textContaining('Filter by date'));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Cancel'));
  await tester.pumpAndSettle();

  // filter by tag
  await tester.tap(find.descendant(
      of: find.byType(TagSelectWidget), matching: find.text(tags.first.name)));
  await tester.pumpAndSettle();
  await tester.tapAt(const Offset(0, 100));
  await tester.pumpAndSettle();
  expect(find.text(todoWithTags.title), findsOneWidget);

  await tester.tap(find.byIcon(Icons.filter_alt_outlined));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Clear'));
  await tester.pumpAndSettle();
  expect(find.byType(TodoPrevWidget), findsNWidgets(todos.length - 1));

  // Search test
  await tester.tapAt(const Offset(0, 100));
  await tester.pumpAndSettle();
  await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('TodoSearchPanel')),
        matching: find.byType(TextField),
      ),
      todoWithTags.title.substring(3, 6));
  await tester.pumpAndSettle();
  expect(find.byType(TodoPrevWidget), findsOneWidget);
}

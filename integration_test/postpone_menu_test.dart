import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

import 'todo_editor_test.mocks.dart';
import 'utils.dart';

/*
Load app only todos with date now visiable
enable see future
 */

@GenerateMocks([IDbService])
void main() async {
  testWidgets('postpone todo test', postponeTodoTest);
}

Future<void> postponeTodoTest(WidgetTester tester) async {
  final db = MockIDbService();
  final now = DateTime.now();
  final tags = List<Tag>.generate(4,
      (i) => Tag.empty().copyWith(id: UniqueId(id: "tag_$i"), name: "tag_$i"));
  final todoWithDate = ToDo.empty()
      .copyWith(title: "Todo_2", id: UniqueId(id: "id_2"), date: now);
  List<ToDo> todos = [todoWithDate];

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags')).thenAnswer(
      (realInvocation) => Stream.fromIterable(tags.map((e) => e.toMap())));
  when(db.getAll(table: 'todos')).thenAnswer(
      (realInvocation) => Stream.fromIterable(todos.map((e) => e.toMap())));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider
          .overrideWith((ref) => '/home/lavruh/Documents/TaggedTodosOrganizer'),
      tagsDbProvider.overrideWith((ref) => db),
      todosDbProvider.overrideWith((ref) => db)
    ],
    child: const MyApp(),
  ));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.filter_alt_outlined));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.textContaining('Show future'));
  await tester.pump(const Duration(seconds: 1));
  await tester.tapAt(const Offset(0, 100));
  await tester.pump(const Duration(seconds: 1));

  expect(find.text(todoWithDate.title), findsOneWidget);
  expect(find.text(DateFormat('y-MM-dd').format(now)), findsOneWidget);
  await tester.tap(find.byKey(const Key('todoPreviewDate')));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text('Postpone till...'), findsOneWidget);
  expect(find.text('Tomorrow'), findsOneWidget);
  expect(find.text('Today'), findsOneWidget);
  expect(find.text('3 days'), findsOneWidget);
  expect(find.text('Next week'), findsOneWidget);
  expect(find.text('6 weeks'), findsOneWidget);
  expect(find.text('Clear Date'), findsOneWidget);

  final tommorow = DateTime(now.year, now.month, now.day + 1);
  await tester.tap(find.text('Tomorrow'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text(DateFormat('y-MM-dd').format(tommorow)), findsOneWidget);
  checkDbUpdated(db);

  await checkMenuItem(tester, 'Today', now);
  checkDbUpdated(db);

  final dateIn3days = postponeDate(now, 3);
  await checkMenuItem(tester, '3 days', dateIn3days);
  checkDbUpdated(db);

  final dateNextWeek = postponeDate(dateIn3days, 7);
  await checkMenuItem(tester, "Next week", dateNextWeek);
  checkDbUpdated(db);

  final date6Week = postponeDate(dateNextWeek, 7 * 6);
  await checkMenuItem(tester, '6 weeks', date6Week);
  checkDbUpdated(db);

  await tester.tap(find.byKey(const Key('todoPreviewDate')));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.text('Clear Date'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('${now.year}'), findsNothing);
  checkDbUpdated(db);
}

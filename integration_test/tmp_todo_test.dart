import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/one_day_view_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todo_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todos_db_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/screens/one_day_view_screen.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'duplicate_todo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
Future<void> tmpTodoTest(WidgetTester tester) async {
  final db = MockIDbService();

  final todoEmpty = ToDo.empty().copyWith(title: "Empty");
  final todoWithSomeDate =
      ToDo.empty().copyWith(date: DateTime(2024, 10, 10), title: "Nov todo");
  final todoToday =
      ToDo.empty().copyWith(date: DateTime.now(), title: "Today todo");
  final todoList = [todoEmpty, todoWithSomeDate, todoToday];

  final tmpTodo = ToDo.empty().copyWith(title: "Tmp todo");

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'todos')).thenAnswer(
      (realInvocation) => Stream.fromIterable(todoList).map((e) => e.toMap()));
  when(db.getAll(table: 'tmp_todos'))
      .thenAnswer((realInvocation) => Stream.fromIterable([tmpTodo.toMap()]));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider
          .overrideWith((ref) => '/home/lavruh/Documents/TaggedTodosOrganizer'),
      todosDbProvider.overrideWith((ref) => db),
      tmpTodosDbProvider.overrideWith((ref) => db),
      attachmentsProvider.overrideWith((ref) => MockAttachmentsNotifier()),
      logProvider.overrideWith((ref) => LogNotifier(ref)),
    ],
    child: const MyApp(),
  ));

  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  final context = tester.element(find.byType(TodosScreen));

  await openOneDayView(tester);
  expect(find.byType(OneDayViewScreen), findsOneWidget);
  final ref = ProviderScope.containerOf(context);

  expect(ref.read(todosProvider).length, todoList.length);
  expect(ref.read(oneDayViewProvider).length, 2);
  expect(find.text(todoToday.title), findsOneWidget);
  expect(find.byTooltip("Open editor"), findsOneWidget);
  await tester.tap(find.byTooltip("Open editor"));
  await tester.pumpAndSettle();
  expect(find.byType(TodoEditScreen), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle();
  await openOneDayView(tester);
  const newTmpTodoTitle = "new title";
  await addNewTmpTodoAndEnterTitle(tester, newTmpTodoTitle);
  expect(ref.read(oneDayViewProvider).length, 3);
  expect(ref.read(tmpTodoProvider).first.title, newTmpTodoTitle);

  final addPermanentTodoButton = find.descendant(
      of: find.ancestor(
          of: find.text(newTmpTodoTitle), matching: find.byType(TextFormField)),
      matching: find.byTooltip("Create permanent"));
  expect(addPermanentTodoButton, findsOneWidget);

  await tester.tap(addPermanentTodoButton);
  await tester.pumpAndSettle();
  expect(find.byType(TodoEditScreen), findsOneWidget);
  await tester.pump(const Duration(seconds: 10));
  expect(ref.read(oneDayViewProvider).length, 3);
  expect(ref.read(tmpTodoProvider).length, 1);
  expect(ref.read(todosProvider).last.title, newTmpTodoTitle);

  // await tester.pump(const Duration(seconds: 10));
}

addNewTmpTodoAndEnterTitle(WidgetTester tester, String s) async {
  final addButton = find.byTooltip("Add tmp todo");
  expect(addButton, findsOneWidget);
  await tester.tap(addButton);
  await tester.pumpAndSettle();
  final input =
      find.descendant(of: find.byType(TextFormField), matching: find.text(""));
  expect(input, findsOneWidget);
  await tester.enterText(input, s);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.pumpAndSettle();
}

openOneDayView(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('One Day View'), findsOneWidget);
  await tester.tap(find.text('One Day View'));
  await tester.pumpAndSettle();
}

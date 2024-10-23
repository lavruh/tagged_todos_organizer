import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'attachments_mock.dart';
import 'duplicate_todo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
Future<void> logServiceTest(WidgetTester tester) async {
  final db = MockIDbService();

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'todos'))
      .thenAnswer((realInvocation) => const Stream.empty());

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider.overrideWith((ref) => '/home/lavruh/Documents/TaggedTodosOrganizer'),
      todosDbProvider.overrideWith((ref) {
        return db;
      }),
      todosProvider.overrideWith((ref) {
        final notifier = TodosNotifier(ref);
        notifier.getTodos();
        return notifier;
      }),
      attachmentsProvider.overrideWith((ref) => AttachmentsNotifierMock(ref)),
      logProvider.overrideWith((ref) => LogNotifier(ref)),
    ],
    child: const MyApp(),
  ));

  await tester.pump();
  await tester.pump(const Duration(seconds: 1));

  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  final context = tester.element(find.byType(TodoEditScreen));
  final ref = ProviderScope.containerOf(context);
  expect(ref.read(logProvider).length, 0);

  const title = "todo name";
  final titleField = find.widgetWithText(TextField, 'Title');
  await tester.enterText(titleField, title);
  await tester.pump(const Duration(seconds: 1));
  final titleCheckIcon =
  find.descendant(of: titleField, matching: find.byIcon(Icons.check));
  await tester.tap(titleCheckIcon);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 1);
  expect(ref.read(logProvider).last.title, title);
  expect(ref.read(logProvider).last.action, LoggableAction.created);
  await tester.tap(find.byType(Checkbox));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 1);
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 2, reason: '${ref.read(logProvider)}');
  expect(ref.read(logProvider).last.title, title);
  expect(ref.read(logProvider).last.action, LoggableAction.done);
  await tester.tap(find.byType(Checkbox));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 2, reason: '${ref.read(logProvider)}');
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 3, reason: '${ref.read(logProvider)}');
  expect(ref.read(logProvider).last.action, LoggableAction.undone);
  await tester.tap(find.descendant(
      of: find.byType(SubTodosOverviewWidget),
      matching: find.byIcon(Icons.add)));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  final contextSub = tester.element(find.byType(TodoEditScreen));
  final refSub = ProviderScope.containerOf(contextSub);
  expect(refSub.read(logProvider).length, 3);

  const titleSubTodo = "sub todo name";
  final subTodoTitleField = find.widgetWithText(TextField, 'Title');
  await tester.enterText(subTodoTitleField, titleSubTodo);
  await tester.pump(const Duration(seconds: 1));
  final subTodoTitleCheckIcon = find.descendant(
    of: subTodoTitleField,
    matching: find.byIcon(Icons.check),
  );
  await tester.tap(subTodoTitleCheckIcon);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.save));
  await tester.pumpAndSettle();
  expect(refSub.read(logProvider).length, 4,
      reason: '${ref.read(logProvider)}');
  expect(refSub.read(logProvider).last.title, titleSubTodo);
  expect(refSub.read(logProvider).last.action, LoggableAction.created);
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byKey(const Key('dialog_confirm')));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 5, reason: '${ref.read(logProvider)}');
  expect(ref.read(logProvider).last.title, titleSubTodo);
  expect(ref.read(logProvider).last.action, LoggableAction.deleted);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 10));


  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('Log'), findsOneWidget);

  await tester.tap(find.text('Log'));
  await tester.pump(const Duration(seconds: 1));
}

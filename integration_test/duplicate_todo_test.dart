import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_db_provider.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'duplicate_todo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
// @GenerateMocks([AttachmentsNotifier,IDbService])
Future<void> duplicateTodoTest(WidgetTester tester) async {
  final db = MockIDbService();

  final logdata = [
    LogEntry(
            id: UniqueId(),
            title: "title",
            date: DateTime.now(),
            tags: [],
            action: LoggableAction.archived)
        .toMap()
  ];

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'todos'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'log'))
      .thenAnswer((realInvocation) => Stream.fromIterable(logdata));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider.overrideWith((ref) => '/home/lavruh/tmp/test'),
      todosDbProvider.overrideWith((ref) => db),
      todosProvider.overrideWith((ref) {
        final notifier = TodosNotifier(ref);
        notifier.getTodos();
        return notifier;
      }),
      logDbProvider.overrideWith((ref) => db),
      logProvider.overrideWith((ref) {
        final notifier = LogNotifier(ref);
        notifier.getAllEntries();
        return notifier;
      }),
    ],
    child: const MyApp(),
  ));

  final context = tester.element(find.byType(TodosScreen));
  final ref = ProviderScope.containerOf(context);
  final todo = ToDo.empty().copyWith(title: 'Some todo');
  final updatedTodo =
      await ref.read(todosProvider.notifier).updateTodo(item: todo);
  ref.read(attachmentsProvider.notifier).manage(
      id: updatedTodo.id.toString(),
      attachmentsDirPath: updatedTodo.attachDirPath,
      createDir: true);
  ref.read(todosProvider.notifier).archiveTodo(todo: updatedTodo);
  // ref.read(logProvider.notifier).logTodoArchived(todo: todo);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 10));
  // expect(ref.read(logProvider).length, 3);

  await tester.pump();
  await openDrawerMenu(tester);
  expect(find.text('Log'), findsOneWidget);

  await tapText(tester, 'Log');
  expect(find.text('Duplicate'), findsOneWidget);

  await tapText(tester, 'Duplicate');
  expect(find.byType(TodoEditScreen), findsOneWidget);
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<void> openDrawerMenu(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
}

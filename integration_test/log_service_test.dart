import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';

Future<void> logServiceTest(WidgetTester tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [
      todosProvider.overrideWith((ref) {
        final notifier = TodosNotifier(ref);
        notifier.getTodos();
        return notifier;
      }),
      logProvider.overrideWith((ref) => LogNotifier(ref)),
    ],
    child: const MyApp(),
  ));

  await tester.pump();
  await tester.pump(const Duration(seconds: 1));

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(const Duration(seconds: 1));
  final context = tester.element(find.byType(TodoEditScreen));
  final ref = ProviderScope.containerOf(context);
  expect(ref.read(logProvider).length, 0);
  const title = "todo name";
  await tester.enterText(find.widgetWithText(TextField, 'Title'), title);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.check));
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
  const titleSubTodo = "sub todo name";
  await tester.enterText(find.widgetWithText(TextField, 'Title'), titleSubTodo);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 4);
  expect(ref.read(logProvider).last.title, titleSubTodo);
  expect(ref.read(logProvider).last.action, LoggableAction.created);
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 5);
  expect(ref.read(logProvider).last.title, titleSubTodo);
  expect(ref.read(logProvider).last.action, LoggableAction.deleted);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byType(Checkbox));
  await tester.pump(const Duration(seconds: 1));
  expect(ref.read(logProvider).length, 6, reason: '${ref.read(logProvider)}');
  expect(ref.read(logProvider).last.action, LoggableAction.done);

  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('Log'), findsOneWidget);

  await tester.tap(find.text('Log'));
  await tester.pump(const Duration(seconds: 1));
}

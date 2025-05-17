import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'duplicate_todo_test.mocks.dart';
import 'utils.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
void main() async {
  testWidgets('log service test', logServiceTest);
}

Future<void> logServiceTest(WidgetTester tester) async {
  final db = MockIDbService();

  clearDirectory(testDirPath);
  final tags = List<Tag>.generate(
      4,
      (i) => Tag.empty().copyWith(
          id: UniqueId(id: "tag_$i"), name: "tag_$i", color: 100 * i));
  final todoWithTags = ToDo.empty().copyWith(
    title: "Todo_1",
    id: UniqueId(id: "id_1"),
    tags: [tags.first.id, tags.last.id],
  );

  when(db.getAll(table: 'tags')).thenAnswer(
      (realInvocation) => Stream.fromIterable(tags.map((e) => e.toMap())));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider.overrideWith((ref) => testDirPath),
      logProvider.overrideWith((ref) => LogNotifier(ref)),
    ],
    child: const MyApp(),
  ));

  await tester.pumpAndSettle();
  var context = tester.element(find.byType(TodosScreen));
  var ref = ProviderScope.containerOf(context);
  ref.read(todosProvider.notifier).updateTodo(item: todoWithTags);
  await pump(tester);

  await tester.tap(find.textContaining(todoWithTags.title));
  await tester.pumpAndSettle();
  context = tester.element(find.byType(TodoEditScreen));
  ref = ProviderScope.containerOf(context);
  expect(ref.read(logProvider).length, 0);

  await tester.tap(find.byType(Checkbox));
  await pump(tester);
  expect(ref.read(logProvider).length, 0);
  expect(find.byTooltip("Reschedule"), findsOneWidget);
  await tester.tap(find.byTooltip("Reschedule"));
  await pump(tester);
  await tester.tap(find.text("Today"));
  await pump(tester);
  expect(ref.read(logProvider).length, 1);
  expect(ref.read(logProvider).last.title, todoWithTags.title);
  expect(ref.read(logProvider).last.action, LoggableAction.done);
  final checkBox = tester.widget<Checkbox>(find.byType(Checkbox));
  expect(checkBox.value, false);
  expect(find.textContaining(DateFormat('dd\nMMM\ny').format(DateTime.now())),
      findsOneWidget);

  final title2 = "second name for todo";
  await enterTextAndConfirm(
    tester,
    find.widgetWithText(TextField, 'Title'),
    title2,
  );
  await tester.tap(find.byIcon(Icons.save));
  await pump(tester);
  await tester.tap(find.byType(Checkbox));
  await pump(tester);
  expect(ref.read(logProvider).length, 1);
  expect(ref.read(logProvider).last.title, todoWithTags.title);
  await tester.tap(find.byIcon(Icons.save));
  await pump(tester);
  expect(ref.read(logProvider).length, 2);
  expect(ref.read(logProvider).last.title, title2);

  await tester.tap(find.byTooltip("Archive"));
  await pump(tester);
  await pump(tester);
  await pump(tester);
  expect(find.textContaining("Archive todo?"), findsOneWidget);
  expect(find.byKey(const Key('dialog_confirm')), findsOneWidget);
  expect(find.byKey(const Key('dialog_cancel')), findsOneWidget);

  await tester.tap(find.byKey(const Key('dialog_confirm')));
  await pump(tester);
  expect(find.byType(TodosScreen), findsOneWidget);
  expect(ref.read(logProvider).length, 3);
  expect(ref.read(logProvider).last.title, title2);
  expect(ref.read(logProvider).last.action, LoggableAction.archived);

  await openDrawerMenu(tester);
  await pump(tester);
  expect(find.text('Log'), findsOneWidget);

  await tester.tap(find.text('Log'));
  await pump(tester);
  expect(find.textContaining(todoWithTags.title), findsOneWidget);
  expect(find.textContaining(title2), findsNWidgets(2));
  expect(find.textContaining("done"), findsNWidgets(2));
  expect(find.textContaining("archived"), findsNWidgets(1));
  expect(find.textContaining("Unarchive"), findsOneWidget);
  expect(find.textContaining("Duplicate"), findsOneWidget);
}

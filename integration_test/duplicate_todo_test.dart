import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

import 'utils.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
void main() async {
  testWidgets('duplicate todo test', duplicateTodoTest);
}

Future<void> duplicateTodoTest(WidgetTester tester) async {
  clearDirectory("");

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider.overrideWith((ref) => testDirPath),
      logProvider.overrideWith(() => LogNotifier()),
    ],
    child: const MyApp(),
  ));

  await tester.pumpAndSettle();

  final todo = ToDo.empty().copyWith(title: 'Some todo');

  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  final titleField = find.widgetWithText(TextField, 'Title');
  await tester.enterText(titleField, todo.title);
  await tester.pump(const Duration(seconds: 1));
  final titleCheckIcon =
      find.descendant(of: titleField, matching: find.byIcon(Icons.check));
  await tester.tap(titleCheckIcon);
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.save));
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.archive));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('dialog_confirm')));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  for (int i = 0; i < 2; i++) {
    await openDrawerMenu(tester);
    expect(find.text('Log'), findsOneWidget);

    await tapText(tester, 'Log');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('Unarchive'), findsOneWidget);

    await tapText(tester, 'Unarchive');
    await tester.pumpAndSettle();
    expect(find.byType(TodoEditScreen), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text(todo.title), findsOneWidget);
    await tester.pumpAndSettle();

    const newTitle = 'Some todo2';
    final titleField2 = find.widgetWithText(TextField, 'Title');
    await tester.enterText(titleField2, newTitle);
    await tester.pump(const Duration(seconds: 1));
    final titleCheckIcon2 =
        find.descendant(of: titleField2, matching: find.byIcon(Icons.check));
    await tester.tap(titleCheckIcon2);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Save changes?'), findsOneWidget);
    if (i == 0) {
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      // expect(find.text(todo.title), findsNothing);
    }
    if (i == 1) {
      await tester.tap(find.byKey(const Key('dialog_confirm')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      expect(find.text(newTitle), findsOneWidget);
    }
  }
}

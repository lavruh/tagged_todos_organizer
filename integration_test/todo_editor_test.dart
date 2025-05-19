
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_part_widget.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_parts_widget.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/todo_prev_widget.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

import 'todo_editor_test.mocks.dart';
import 'utils.dart';

/*
1.
Load app
    find 1 todo with tags and last line of description 
    find 1 todo with date
2.
Click on todo with date
    open editor
    find title
    find description
    find date
    find text tags

3.
Click on first todo
    open editor
    find icons save and delete
    find name field
    find decription text
    find Attachements
    find Used parts 
    find Sub tasks

4.
Tap on Subtask add icon
    find name empty
    find description empty
    find tags same like parent
    find Go parent text

5.
Enter title text
Save Todo

6.
Tap text Go parent
    find parent name
    find Go parent missing

7.
Tap on add sub task again
Go back without saving.
    finds that no new task created

8.
Expand sub todos and find sub todo title

9.
Tap delete icon
    find delete todo
    find cancel 
10.
Tap cancel
    find todo name
    check state => todo exists
11.
Tap delete icon
Tap confirm icon
    find todo widgets 1pc
    find deleted todo missing
    check state if todo missing

12.
Tap add icon
    find name field blank
    find text description
    find text Tags
    find attachements = 0
    find state does not contain new todo
*/

@GenerateMocks([IDbService, AttachmentsNotifier])


void main() async {
  testWidgets('todo editor test', todoEditorTest);
}


Future<void> todoEditorTest(WidgetTester tester) async {
    clearDirectory(testDirPath);
    final db = MockIDbService();
    final tags = List<Tag>.generate(
        4,
        (i) => Tag.empty().copyWith(
            id: UniqueId(id: "tag_$i"), name: "tag_$i", color: 100 * i));
    final todoDate = DateTime(2022, 3, 3);
    const descriptionLineToSee = 'some information';
    final todoWithTags = ToDo.empty().copyWith(
      title: "Todo_1",
      id: UniqueId(id: "id_1"),
      description: "line1 \n line2 \n $descriptionLineToSee",
      tags: [tags.first.id, tags.last.id],
    );
    final todoWithDate = ToDo.empty().copyWith(
      title: "Todo_2",
      id: UniqueId(id: "id_2"),
      date: todoDate,
    );
    List<ToDo> todos = [todoWithTags, todoWithDate];

    when(db.getAll(table: anyNamed('table')))
        .thenAnswer((realInvocation) => const Stream.empty());
    when(db.getAll(table: 'tags')).thenAnswer(
        (realInvocation) => Stream.fromIterable(tags.map((e) => e.toMap())));


    await tester.pumpWidget(ProviderScope(
      overrides: [
        appPathProvider.overrideWithValue(testDirPath),
        tagsDbProvider.overrideWith((ref) => db),
        logProvider.overrideWith((ref) => LogNotifier(ref)),
      ],
      child: const MyApp(),
    ));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TodosScreen));
    final ref = ProviderScope.containerOf(context);
    ref.read(todosProvider.notifier).updateTodo(item: todoWithTags);
    ref.read(todosProvider.notifier).updateTodo(item: todoWithDate);
    await tester.pumpAndSettle();
    // 1.
    expect(find.byType(TodoPrevWidget), findsNWidgets(todos.length));
    expect(find.text(todos.first.title), findsOneWidget);
    expect(find.textContaining(descriptionLineToSee), findsOneWidget);
    expect(find.text(tags.first.name), findsOneWidget);

    expect(
        find.descendant(
            of: find.byType(TagsPreviewWidget),
            matching: find.byType(TagWidget)),
        findsNWidgets(todoWithTags.tags.length));

    expect(find.text(todoWithTags.title), findsOneWidget);
    expect(find.text(DateFormat('y-MM-dd').format(todoDate)), findsOneWidget);
    expect(find.text("Tags:"), findsOneWidget);

    // 2.
    await tester.tap(find.text(todoWithDate.title));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.text(todoWithDate.title), findsOneWidget);
    expect(
        find.text(DateFormat('dd\nMMM\ny').format(todoDate)), findsOneWidget);
    expect(find.text("Tags:"), findsOneWidget);

    // 3.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text(todoWithTags.title));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.text(todoWithTags.title), findsOneWidget);
    expect(find.textContaining(todoWithTags.description), findsOneWidget);
    expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);
    expect(find.text("Tags:"), findsNothing);
    expect(find.textContaining("Attachments"), findsOneWidget);
    expect(find.textContaining("Used parts"), findsOneWidget);
    expect(find.textContaining("Sub tasks"), findsOneWidget);
    // expect(find.text("Go parent"), findsNothing);

    // 4.
    final subTodoAddButton = find.byTooltip("Add sub todo");
    expect(subTodoAddButton, findsOneWidget);
    await tester.tap(subTodoAddButton);
    await tester.pumpAndSettle();
    expect(find.text("Go parent"), findsOneWidget);
    expect(find.text("Title"), findsOneWidget);
    expect(find.text("Description"), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(TagsPreviewWidget),
            matching: find.byType(TagWidget)),
        findsNWidgets(todoWithTags.tags.length));

    // 5.
    const newSubtaskName = 'new sub task';
    final titleField = find.widgetWithText(TextField, "Title");
    await tester.enterText(titleField, newSubtaskName);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final titleCheckIcon =
        find.descendant(of: titleField, matching: find.byIcon(Icons.check));
    await tester.tap(titleCheckIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // 6.
    await tester.tap(find.text("Go parent"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.textContaining('Sub tasks (1)'), findsOneWidget);
    // expect(find.text("Go parent"), findsNothing);

    // 7.
    await tester.tap(find.descendant(
        of: find.byType(SubTodosOverviewWidget),
        matching: find.byIcon(Icons.add)));
    await tester.pumpAndSettle();

    // uncomment to recreate problem with null on editor
    // await tester.tap(find.byIcon(Icons.save));
    // await tester.pumpAndSettle();

    await tester.tap(find.text("Go parent"));
    await tester.pumpAndSettle();
    expect(find.text(todoWithTags.title), findsOneWidget);
    expect(find.textContaining(todoWithTags.description), findsOneWidget);
    // expect(find.text("Go parent"), findsNothing);
    expect(find.textContaining('Sub tasks (1)'), findsOneWidget);

    // 8.
    await tester.tap(find.byType(SubTodosOverviewWidget));
    await tester.pumpAndSettle();
    expect(find.text(newSubtaskName), findsOneWidget);

    // 9.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.textContaining('Delete'), findsOneWidget);

    // 10.
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();
    expect(find.textContaining(todoWithTags.title), findsOneWidget);

    // 11.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dialog_confirm')));
    await tester.pumpAndSettle();
    expect(find.textContaining(todoWithTags.title), findsNothing);
    expect(find.byType(TodoPrevWidget), findsNWidgets(todos.length - 1));

    // 12.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    // expect(find.text("Go parent"), findsNothing);
    expect(find.text("Title"), findsOneWidget);
    expect(find.text("Description"), findsOneWidget);
    expect(find.text("Tags:"), findsOneWidget);

    final usedPartsWidget = find.byType(UsedPartsWidget);
    await tester.tap(usedPartsWidget);
    await tester.pumpAndSettle();
    await tester.tap(
        find.descendant(of: usedPartsWidget, matching: find.byIcon(Icons.add)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Used parts (1)'), findsOneWidget);
    expect(find.byType(UsedPartWidget), findsOneWidget);
    expect(find.text('Maximo'), findsOneWidget);
    expect(find.text('name'), findsOneWidget);
    expect(find.text('bin'), findsOneWidget);

    const maximoNo = '6.123.123';
    const maximoPartName = 'SomePartName';
    when(db.getItemByFieldValue(
            request: {'maximoNo': maximoNo}, table: 'parts'))
        .thenAnswer((_) async => Part(
                maximoNo: maximoNo,
                name: maximoPartName,
                catalogNo: '',
                modelNo: '',
                modelNoVessel: '',
                manufacturer: '',
                bin: '',
                dwg: '',
                pos: '',
                balance: '')
            .toMap());
    final maximoField = find.widgetWithText(TextField, 'Maximo');
    await tester.enterText(maximoField, maximoNo);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.tap(
        find.descendant(of: maximoField, matching: find.byIcon(Icons.check)));
    await tester.pumpAndSettle();
    expect(find.text(maximoPartName), findsOneWidget);

    await tester.pageBack();
}

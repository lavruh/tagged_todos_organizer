import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todos_db_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_alias_editor_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_alias_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_db_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'duplicate_todo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AttachmentsNotifier>(), MockSpec<IDbService>()])
void main() async {
  testWidgets('tags alias test', tagsAliasTest);
}

Future<void> tagsAliasTest(WidgetTester tester) async {
  final db = MockIDbService();

  final tagJet = Tag.empty().copyWith(name: 'jet');
  final tagPump = Tag.empty().copyWith(name: 'pump', id: UniqueId(id: '1'));

  final aliasJP = TagsAlias(title: "jp", tags: [tagPump.id]);

  when(db.getAll(table: anyNamed('table')))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags')).thenAnswer((realInvocation) =>
      Stream.fromIterable([tagJet.toMap(), tagPump.toMap()]));
  when(db.getAll(table: 'todos'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tmp_todos'))
      .thenAnswer((realInvocation) => const Stream.empty());
  when(db.getAll(table: 'tags_aliases'))
      .thenAnswer((realInvocation) => Stream.fromIterable([aliasJP.toMap()]));

  await tester.pumpWidget(ProviderScope(
    overrides: [
      appPathProvider
          .overrideWith((ref) => '/home/lavruh/Documents/TaggedTodosOrganizer'),
      todosDbProvider.overrideWith((ref) => db),
      tmpTodosDbProvider.overrideWith((ref) => db),
      attachmentsProvider.overrideWith(() => MockAttachmentsNotifier()),
      tagsDbProvider.overrideWith((ref) => db),
      tagsAliasesDbProvider.overrideWith((ref) => db),
      logProvider.overrideWith(() => LogNotifier()),
    ],
    child: const MyApp(),
  ));

  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  final context = tester.element(find.byType(TodosScreen));

  await openTagsAliasesEditor(tester);
  final ref = ProviderScope.containerOf(context);

  await tester.pumpAndSettle();

  expect(ref.read(tagsAliasesProvider).length, 1);
  expect(find.text(aliasJP.title), findsOneWidget);
  expect(find.text(tagJet.name), findsOneWidget);
  expect(find.text(tagPump.name), findsNWidgets(2));
  expect(find.text("Alias"), findsOneWidget);
  expect(find.byIcon(Icons.delete), findsOneWidget);

  const newAliasTitle = "test_alias";
  await enterAliasTitle(tester, newAliasTitle);
  await tester.pumpAndSettle();
  await tester.tap(find.ancestor(
      of: find.text(tagJet.name), matching: find.byType(InputChip)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key("SaveAliasButton")));
  await tester.pumpAndSettle();

  expect(ref.read(tagsAliasesProvider).length, 2);
  expect(find.text(newAliasTitle), findsOneWidget);
  expect(find.text(tagJet.name), findsNWidgets(2));
  expect(find.text("Alias"), findsOneWidget);

  await tester.tap(find.text(newAliasTitle));
  await tester.pumpAndSettle();
  expect(find.text(newAliasTitle), findsNWidgets(2));

  await tester.tap(find.descendant(
      of: find.byType(TagsAliasEditorWidget),
      matching: find.text(tagPump.name)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key("SaveAliasButton")));
  await tester.pumpAndSettle();
  final aliasWidget = find.ancestor(
      of: find.text(newAliasTitle), matching: find.byType(TagsAliasWidget));


  expect(aliasWidget, findsOneWidget);
  expect(find.descendant(of: aliasWidget, matching: find.text(tagPump.name)),
      findsOneWidget);

  await tester.tap(
      find.descendant(of: aliasWidget, matching: find.byIcon(Icons.delete)));
  await tester.pumpAndSettle();

  expect(ref.read(tagsAliasesProvider).length, 1);
  expect(find.text(newAliasTitle), findsNothing);
}

// PAUSE(WidgetTester tester) async =>
//     await tester.pump(const Duration(seconds: 10));

enterAliasTitle(WidgetTester tester, String s) async {
  final editorTitle = find.byKey(const Key("AliasTitleEditor"));
  await tester.enterText(editorTitle, s);
  await tester.pumpAndSettle();
  final check =
      find.descendant(of: editorTitle, matching: find.byIcon(Icons.check));
  await tester.tap(check);
  await tester.pumpAndSettle();
}

openTagsAliasesEditor(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('Tags Editor'), findsOneWidget);
  await tester.tap(find.text('Tags Editor'));
  await tester.pumpAndSettle();
  expect(find.byTooltip("Edit alias"), findsOneWidget);
  await tester.tap(find.byTooltip("Edit alias"));
  await tester.pumpAndSettle();
}

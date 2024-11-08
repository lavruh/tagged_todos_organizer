import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'tags_aliases_provider_test.mocks.dart';

class TagsProviderListener extends Mock {
  void call(List<Tag>? previous, List<Tag> value);
}

class TagsAliasesProviderListener extends Mock {
  void call(Map<String, TagsAlias>? previous, Map<String, TagsAlias> value);
}

@GenerateMocks([IDbService])
void main() {
  late IDbService db;
  final tag = Tag.empty();
  final tag2 =
      Tag(id: UniqueId(id: 'new_test_tag'), name: 'n', color: 0, group: '');

  final alias = TagsAlias(title: "gb", tags: [tag.id, tag2.id]);

  late ProviderContainer ref;

  setUp(() async {
    db = MockIDbService();

    when(db.getAll(table: 'tags'))
        .thenAnswer((_) => Stream.fromIterable([tag.toMap(), tag2.toMap()]));
    when(db.getAll(table: "tags_aliases"))
        .thenAnswer((_) => Stream.fromIterable([alias.toMap()]));

    ref = ProviderContainer(overrides: [
      tagsAliasesDbProvider.overrideWith((ref) => db),
      tagsDbProvider.overrideWith((ref) => db),
    ]);
    addTearDown(ref.dispose);
    ref.listen<List<Tag>>(tagsProvider, TagsProviderListener().call,
        fireImmediately: true);
    ref.listen<Map<String, TagsAlias>>(
        tagsAliasesProvider, TagsAliasesProviderListener().call,
        fireImmediately: true);
    final tagsNotifier = ref.read(tagsProvider.notifier);
    await tagsNotifier.getTags();
  });

  test('create tags alias', () async {
    final sut = ref.read(tagsAliasesProvider.notifier);
    expect(ref.read(tagsProvider), contains(tag));
    sut.updateAlias(alias: alias);
    verify(db.update(id: alias.id.id, item: alias.toMap(), table: sut.table)).called(1);
    expect(ref.read(tagsAliasesProvider).keys, contains(alias.title));
    expect(ref.read(tagsAliasesProvider).values, contains(alias));
  });

  test("get all aliases", () async {
    final sut = ref.read(tagsAliasesProvider.notifier);
    expect(ref.read(tagsProvider), contains(tag));

    verify(db.getAll(table: sut.table)).called(1);
    expect(ref.read(tagsAliasesProvider).keys, contains(alias.title));
  });
  test("update alias", () {
    final sut = ref.read(tagsAliasesProvider.notifier);

    final newAlias = alias.copyWith(title: "jp", tags: [tag2.id]);
    sut.updateAlias(alias: newAlias);
    verify(db.update(id: alias.id.id, item: newAlias.toMap(), table: sut.table));

    expect(ref.read(tagsAliasesProvider).keys, contains(newAlias.title));
    expect(ref.read(tagsAliasesProvider).values.length, 1);
    expect(ref.read(tagsAliasesProvider).values.first, newAlias);
  });
  test("delete alias", () {
    final sut = ref.read(tagsAliasesProvider.notifier);
    expect(ref.read(tagsAliasesProvider).values.length, 1);
    sut.deleteAlias(alias: alias);
    verify(db.delete(id: alias.id.id, table: sut.table));
    expect(ref.read(tagsAliasesProvider).keys, isNot(contains(alias.title)));
    expect(ref.read(tagsAliasesProvider).values.length, 0);
  });
}

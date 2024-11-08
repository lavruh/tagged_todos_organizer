import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

part 'tags_aliases_provider.g.dart';

@Riverpod(keepAlive: true)
class TagsAliases extends _$TagsAliases {
  IDbService? _db;
  final table = "tags_aliases";

  @override
  Map<String, TagsAlias> build() {
    ref.watch(tagsAliasesDbProvider).whenData((db) => setDb(db));
    getAliases();
    return {};
  }

  setDb(IDbService service) => _db = service;

  bool checkIfAliasExists(alias) => state.containsKey(alias);

  List<Tag> getRelatedTags(String alias) {
    if (!checkIfAliasExists(alias)) return [];
    final tagsIds = state[alias]?.tags;
    if (tagsIds == null) return [];
    List<Tag> res = [];
    for (final id in tagsIds) {
      final tags = ref.read(tagsProvider).where((e) => e.id == id);
      if (tags.isNotEmpty) res.addAll(tags);
    }
    return res;
  }

  getAliases() async {
    final db = _db;
    if (db == null) return;
    await for (final map in db.getAll(table: table)) {
      final alias = TagsAlias.fromMap(map);
      state.putIfAbsent(alias.title, () => alias);
    }
    state = {...state};
  }

  updateAlias({required TagsAlias alias}) {
    final db = _db;
    if (db == null) return;
    state.removeWhere((title, a) => a.id == alias.id);
    state[alias.title] = alias;
    state = {...state};
    db.update(id: alias.id.id, item: alias.toMap(), table: table);
  }

  deleteAlias({required TagsAlias alias}) {
    final db = _db;
    if (db == null) return;
    state.remove(alias.title);
    state = {...state};
    db.delete(id: alias.id.id, table: table);
  }
}

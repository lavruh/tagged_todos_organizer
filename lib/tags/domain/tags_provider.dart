import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final tagsProvider =
    NotifierProvider<TagsNotifier, List<Tag>>(() => TagsNotifier());

class TagsNotifier extends Notifier<List<Tag>> {
  IDbService? db;

  @override
  build() {
    ref.watch(tagsDbProvider).whenData((db) => setDb(db));
    getTags();
    return [];
  }

  void setDb(IDbService service) => db = service;

  Future<void> getTags() async {
    final tagsStream = db?.getAll(table: 'tags');
    if (tagsStream != null) {
      await for (final Map<String, dynamic> map in tagsStream) {
        state = [...state, Tag.fromMap(map)];
      }
    }
  }

  void addTag({Tag? tag}) {
    if (tag != null) {
      state = [...state, tag];
      return;
    }
    if (isContainsTag(tag: Tag.withName('')) == null) {
      state = [...state, Tag.empty()];
    }
  }

  void deleteTag(UniqueId id) {
    db?.delete(id: id.toString(), table: 'tags');
    state = [...state.where((tag) => tag.id != id)];
    ref.read(todosProvider.notifier).checkAndCleanTodos();
  }

  void updateTag(Tag newTag) {
    db?.update(id: newTag.id.toString(), item: newTag.toMap(), table: 'tags');
    int index = state.indexWhere((e) => e.id == newTag.id);
    if (index > -1) {
      state.removeAt(index);
      state.insert(index, newTag);
      state = [...state];
    } else {
      addTag(tag: newTag);
    }
  }

  String? isContainsTag({required Tag tag}) {
    if (state
        .any((element) => element.name == tag.name && element.id != tag.id)) {
      return "Tag with name: ${tag.name} exists";
    }
    return null;
  }

  bool isTagIdExists(UniqueId id) {
    return state.any((element) => element.id == id);
  }
}

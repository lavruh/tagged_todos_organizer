import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final tagsProvider = StateNotifierProvider<TagsNotifier, List<Tag>>((ref) {
  var notifier = TagsNotifier(ref);
  ref.watch(tagsDbProvider).whenData((db) {
    notifier.setDb(db);
  });
  notifier.getTags();
  return notifier;
});

class TagsNotifier extends StateNotifier<List<Tag>> {
  IDbService? db;

  Ref ref;
  TagsNotifier(this.ref) : super([]);
  setDb(IDbService service) {
    db = service;
  }

  getTags() async {
    final tagsStream = db?.getAll(table: 'tags');
    if (tagsStream != null) {
      await for (final Map<String, dynamic> map in tagsStream) {
        state = [...state, Tag.fromMap(map)];
      }
    }
  }

  addTag({Tag? tag}) {
    if (tag != null) {
      state = [...state, tag];
      return;
    }
    if (isContainsTag(tag: Tag.withName('')) == null) {
      state = [...state, Tag.empty()];
    }
  }

  deleteTag(UniqueId id) {
    db?.delete(id: id.toString(), table: 'tags');
    state = [...state.where((tag) => tag.id != id)];
    ref.read(todosProvider.notifier).checkAndCleanTodos();
  }

  updateTag(Tag newTag) {
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/data/i_tags_db_service.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final tagsProvider = StateNotifierProvider<TagsNotifier, List<Tag>>((ref) {
  var notifier = TagsNotifier();
  ref.watch(tagsDbProvider).whenData((db) {
    notifier.setDb(db);
  });
  notifier.getTags();
  return notifier;
});

class TagsNotifier extends StateNotifier<List<Tag>> {
  ITagsDbService? db;
  TagsNotifier() : super([]);
  setDb(ITagsDbService service) {
    db = service;
  }

  getTags() async {
    final tagsStream = db?.getTags();
    if (tagsStream != null) {
      await for (final Map<String, dynamic> map in tagsStream) {
        state = [...state, Tag.fromMap(map)];
      }
    }
  }

  addTag() {
    if (isContainsTag(tag: Tag.withName('')) == null) {
      state = [...state, Tag.empty()];
    }
  }

  deleteTag(UniqueId id) {
    db?.deleteTag(id: id.toString());
    state = [...state.where((tag) => tag.id != id)];
  }

  updateTag(Tag newTag) {
    db?.updateTag(id: newTag.id.toString(), item: newTag.toMap());
    int index = state.indexWhere((e) => e.id == newTag.id);
    state.removeAt(index);
    state.insert(index, newTag);
    state = [...state];
  }

  String? isContainsTag({required Tag tag}) {
    if (state
        .any((element) => element.name == tag.name && element.id != tag.id)) {
      return "Tag with name: ${tag.name} exists";
    }
    return null;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final tagsProvider =
    StateNotifierProvider<TagsNotifier, List<Tag>>((ref) => TagsNotifier());

class TagsNotifier extends StateNotifier<List<Tag>> {
  TagsNotifier() : super([]);

  addTag() {
    if (isContainsTag(tag: Tag.withName('')) == null) {
      state = [...state, Tag.empty()];
    }
  }

  deleteTag(UniqueId id) {
    state = [...state.where((tag) => tag.id != id)];
  }

  updateTag(Tag newTag) {
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

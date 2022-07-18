import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final tagsProvider =
    StateNotifierProvider<TagsNotifier, List<Tag>>((ref) => TagsNotifier());

class TagsNotifier extends StateNotifier<List<Tag>> {
  TagsNotifier() : super([]);

  addTag() => state = [
        ...state,
        Tag.empty(),
      ];

  removeTag(UniqueId id) {
    state = [...state.where((tag) => tag.id != id)];
  }
}

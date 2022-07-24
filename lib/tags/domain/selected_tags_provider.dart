import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final selectedTagsProvider =
    StateProvider.family<List<Tag>, List<UniqueId>>((ref, List<UniqueId> tags) {
  final availableTags = ref.watch(tagsProvider);
  return availableTags.where((element) => tags.contains(element.id)).toList();
});

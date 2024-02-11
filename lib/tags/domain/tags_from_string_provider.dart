import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';

final tagsFromStringSearchProvider = StateProvider((ref) => "");

final tagsFromStringProvider = StateProvider<List<Tag>>((ref) {
  final availableTags = ref.watch(tagsProvider);
  final selectedTags = ref.watch(filterByTagsProvider);
  final str = ref.watch(tagsFromStringSearchProvider);
  final tagNames = str.split(' ');
  List<Tag> res =
      availableTags.where((e) => selectedTags.contains(e.id)).toList();
  if (str.length > 1) {
    return [
      ...res,
      ...availableTags.where((tag) =>
          tagNames.any((name) => tag.name.contains(name)) && !res.contains(tag))
    ];
  }
  return res;
});

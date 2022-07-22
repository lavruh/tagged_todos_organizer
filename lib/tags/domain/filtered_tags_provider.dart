import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';

enum TagsSortOption { noSort, az, za }

final filteredTagsProvider = Provider<List<Tag>>((ref) {
  final tags = ref.watch(tagsProvider);
  final filter = ref.watch(tagsFilter);
  final sortOrder = ref.watch(tagsSortOrder);
  if (sortOrder == TagsSortOption.az) {
    tags.sort((a, b) => a.name.compareTo(b.name));
  }
  if (sortOrder == TagsSortOption.za) {
    tags.sort((a, b) => b.name.compareTo(a.name));
  }
  return tags
      .where((tag) => tag.name.contains(filter) || filter == '')
      .toList();
});

final tagsFilter = StateProvider<String>((ref) => '');

final tagsSortOrder =
    StateProvider<TagsSortOption>((ref) => TagsSortOption.noSort);

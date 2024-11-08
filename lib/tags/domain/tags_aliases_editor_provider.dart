import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tags_aliases_editor_provider.g.dart';

@riverpod
class TagsAliasesEditor extends _$TagsAliasesEditor {
  @override
  TagsAlias build() => TagsAlias.empty();

  void updateAlias({required TagsAlias alias}) {
    state = alias;
  }

  void updateTitle({required String title}) {
    state = state.copyWith(title: title);
  }

  void toggleTag(Tag tag) {
    final tags = state.tags;
    if (tags.contains(tag.id)) {
      tags.remove(tag.id);
    } else {
      tags.add(tag.id);
    }
    state = state.copyWith(tags: tags.toList());
  }
}

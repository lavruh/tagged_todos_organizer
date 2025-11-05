import 'package:flutter_riverpod/legacy.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';

final tagEditorProvider = StateProvider<TagEditor?>((ref) => null);

class TagEditor {
  final Tag item;
  final bool isChanged;
  TagEditor({
    required this.item,
    required this.isChanged,
  });

  TagEditor copyWith({
    Tag? item,
    bool? isChanged,
  }) {
    return TagEditor(
      item: item ?? this.item,
      isChanged: isChanged ?? this.isChanged,
    );
  }
}

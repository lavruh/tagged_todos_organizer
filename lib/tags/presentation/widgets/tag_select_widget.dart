import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/search_panel_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagSelectWidget extends ConsumerWidget {
  const TagSelectWidget({
    this.onPress,
    this.onDelete,
    this.selectedTags,
    Key? key,
  }) : super(key: key);
  final Function(Tag)? onPress;
  final Function(Tag)? onDelete;
  final List<UniqueId>? selectedTags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredTagsProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 3,
                children: items.map((e) {
                  return InputChip(
                    selected: _isSelected(e.id),
                    label: Text(e.name),
                    backgroundColor: Color(e.color),
                    selectedColor: Color(e.color),
                    onPressed: onPress != null ? () => onPress!(e) : null,
                    onDeleted: onDelete != null ? () => onDelete!(e) : null,
                  );
                }).toList(),
              ),
            ),
          ),
          const SearchPanelWidget(),
        ],
      ),
    );
  }

  bool _isSelected(UniqueId id) {
    return selectedTags?.contains(id) ?? false;
  }
}

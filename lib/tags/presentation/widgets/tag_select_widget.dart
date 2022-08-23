import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Wrap(
                children: items.map((e) {
                  return SizedBox(
                    height: 40,
                    child: FittedBox(
                      child: InputChip(
                        selected: _isSelected(e.id),
                        label: Text(
                          e.name,
                          textScaleFactor: 1.2,
                        ),
                        backgroundColor: Color(e.color),
                        selectedColor: Color(e.color),
                        onPressed: onPress != null ? () => onPress!(e) : null,
                        onDeleted: onDelete != null ? () => onDelete!(e) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        if (selectedTags != null)
          SearchPanelWidget(
            onSearch: (String val) {
              ref.read(tagsFilter.notifier).update((state) => val);
            },
          ),
      ],
    );
  }

  bool _isSelected(UniqueId id) {
    return selectedTags?.contains(id) ?? false;
  }
}

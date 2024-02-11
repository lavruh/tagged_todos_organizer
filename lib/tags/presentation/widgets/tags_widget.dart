import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagsWidget extends StatefulWidget {
  const TagsWidget({
    super.key,
    required this.tags,
    required this.updateTags,
  });
  final List<UniqueId> tags;
  final Function(List<UniqueId>) updateTags;
  @override
  State<TagsWidget> createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  List<UniqueId> tags = [];
  bool editMode = false;

  @override
  void initState() {
    tags = [...widget.tags];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: Card(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              editMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TagsPreviewWidget(tags: tags, onTapTag: _removeTappedTag),
                IconButton(
                    onPressed: _setEditMode, icon: const Icon(Icons.edit))
              ],
            ),
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: _updateSelectedTags, child: const Text('Confirm')),
              TagSelectWidget(
                  selectedTags: tags,
                  height: 0.1,
                  onPress: _toggleTagSelection),
            ],
          ),
        ),
      ),
    );
  }

  _toggleTagSelection(tag) {
    if (!tags.contains(tag.id)) {
      tags.add(tag.id);
    } else {
      tags.remove(tag.id);
    }
    setState(() {});
  }

  void _updateSelectedTags() {
    widget.updateTags(tags);
  }

  void _removeTappedTag(tag) => setState(() {
        tags.remove(tag.id);
        widget.updateTags(tags);
      });

  void _setEditMode() => setState(() {
        editMode = true;
      });
}

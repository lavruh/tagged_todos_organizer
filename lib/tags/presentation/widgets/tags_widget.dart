import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagsWidget extends StatefulWidget {
  const TagsWidget({
    Key? key,
    required this.tags,
    required this.updateTags,
  }) : super(key: key);
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
    tags = widget.tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState:
          editMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: TagsPreviewWidget(
        tags: tags,
        onTap: _toggleMode,
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton(onPressed: _toggleMode, child: const Text('Confirm')),
          TagSelectWidget(
            selectedTags: tags,
            onPress: (tag) {
              if (!tags.contains(tag.id)) {
                tags.add(tag.id);
              } else {
                tags.remove(tag.id);
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  _toggleMode() {
    setState(() {
      editMode = !editMode;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_edit_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';

class TagsEditScreen extends ConsumerWidget {
  const TagsEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => ref.read(tagsProvider.notifier).addTag(),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TagEditWidget(),
          TagSelectWidget(
              onPress: (tag) => _setToEdit(ref, tag),
              onDelete: (tag) =>
                  ref.read(tagsProvider.notifier).deleteTag(tag.id))
        ],
      ),
    );
  }

  _setToEdit(WidgetRef ref, Tag e) {
    {
      ref
          .read(tagEditorProvider.notifier)
          .update((state) => TagEditor(item: e, isChanged: false));
    }
  }
}

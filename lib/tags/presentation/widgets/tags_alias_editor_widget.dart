import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class TagsAliasEditorWidget extends ConsumerWidget {
  const TagsAliasEditorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(tagsAliasesEditorProvider);
    final editor = ref.read(tagsAliasesEditorProvider.notifier);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              key: Key(item.title),
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWithConfirm(
                  key: const Key("AliasTitleEditor"),
                  text: item.title,
                  label: "Alias",
                  onConfirm: (val) => editor.updateTitle(title: val)),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    child: TagSelectWidget(
                  height: 0.1,
                  selectedTags: item.tags,
                  onPress: (tag) => editor.toggleTag(tag),
                )),
                IconButton(
                    key: const Key("SaveAliasButton"),
                    onPressed: () {
                      final item = ref.read(tagsAliasesEditorProvider);
                      ref
                          .read(tagsAliasesProvider.notifier)
                          .updateAlias(alias: item);
                      editor.updateAlias(alias: TagsAlias.empty());
                    },
                    icon: const Icon(Icons.check))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

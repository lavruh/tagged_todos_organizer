import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/color_picker_widget.dart';

class TagEditWidget extends ConsumerWidget {
  const TagEditWidget({required this.editor, Key? key}) : super(key: key);
  final TagEditor editor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController(text: editor.item.name);
    final formKey = GlobalKey<FormState>();
    return Card(
        child: ListTile(
      leading: IconButton(
        onPressed: () => _showColorPicker(context, ref),
        icon: Icon(Icons.color_lens, color: Color(editor.item.color)),
      ),
      title: Form(
        key: formKey,
        child: TextFormField(
          controller: textController,
          validator: (v) =>
              ref.read(tagsProvider.notifier).isContainsTag(tag: editor.item),
          decoration: const InputDecoration(labelText: "Tag name"),
          onFieldSubmitted: (val) => _updateText(val, ref),
        ),
      ),
      trailing: editor.isChanged
          ? IconButton(
              onPressed: () => _confirmUpdate(ref, formKey),
              icon: const Icon(Icons.check))
          : null,
    ));
  }

  _showColorPicker(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) => ColorPickerWidget(
              initColor: editor.item.color,
              onSet: (val) {
                final newItem = editor.item.copyWith(color: val);
                ref.read(tagEditorProvider.notifier).update(
                    (state) => editor.copyWith(item: newItem, isChanged: true));
              },
            ));
  }

  _confirmUpdate(WidgetRef ref, GlobalKey<FormState> formKey) {
    final tags = ref.read(tagsProvider.notifier);
    if (formKey.currentState!.validate()) {
      tags.updateTag(editor.item);
      ref.read(tagEditorProvider.notifier).update((state) => null);
    }
  }

  _updateText(String val, WidgetRef ref) {
    {
      final newItem = editor.item.copyWith(name: val);
      ref
          .read(tagEditorProvider.notifier)
          .update((state) => editor.copyWith(item: newItem, isChanged: true));
    }
  }
}

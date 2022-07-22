import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/color_picker_widget.dart';

class TagEditWidget extends ConsumerWidget {
  const TagEditWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(tagEditorProvider);
    final formKey = GlobalKey<FormState>();
    Widget editField = Container();
    if (editor != null) {
      final textController = TextEditingController(text: editor.item.name);
      editField = Card(
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

    return AnimatedCrossFade(
        firstChild: Container(),
        secondChild: editField,
        crossFadeState: editor != null
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250));
  }

  _showColorPicker(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(tagEditorProvider);
    showDialog(
        context: context,
        builder: (context) => ColorPickerWidget(
              initColor: editor!.item.color,
              onSet: (val) {
                final newItem = editor.item.copyWith(color: val);
                ref.read(tagEditorProvider.notifier).update(
                    (state) => editor.copyWith(item: newItem, isChanged: true));
              },
            ));
  }

  _confirmUpdate(WidgetRef ref, GlobalKey<FormState> formKey) {
    final editor = ref.watch(tagEditorProvider);
    final tags = ref.read(tagsProvider.notifier);
    if (formKey.currentState!.validate()) {
      tags.updateTag(editor!.item);
      ref.read(tagEditorProvider.notifier).update((state) => null);
    }
  }

  _updateText(String val, WidgetRef ref) {
    final editor = ref.watch(tagEditorProvider);
    {
      final newItem = editor!.item.copyWith(name: val);
      ref
          .read(tagEditorProvider.notifier)
          .update((state) => editor.copyWith(item: newItem, isChanged: true));
    }
  }
}

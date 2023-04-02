import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagSelectWidget extends ConsumerWidget {
  const TagSelectWidget({
    this.onPress,
    this.onDelete,
    this.selectedTags,
    this.height,
    Key? key,
  }) : super(key: key);
  final Function(Tag)? onPress;
  final Function(Tag)? onDelete;
  final List<UniqueId>? selectedTags;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredTagsProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Platform.isAndroid
            ? FittedBox(fit: BoxFit.cover, child: _tagsWidget(items, context))
            : _tagsWidget(items, context),
        if (selectedTags != null)
          SearchPanelWidget(
            initSearchText: ref.watch(tagsFilter),
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

  Widget _tagsWidget(List<Tag> items, BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * (height ?? 1),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 3.0,
            runSpacing: 3.0,
            children: items.map((e) {
              return TagWidget(
                e: e,
                selected: _isSelected(e.id),
                onPress: onPress != null ? (tag) => onPress!(tag) : null,
                onDelete: onDelete != null ? (tag) => onDelete!(tag) : null,
              );
            }).toList(),
          ),
        ));
  }
}

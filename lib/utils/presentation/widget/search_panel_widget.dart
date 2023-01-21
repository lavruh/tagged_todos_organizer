import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_clear_button.dart';

class SearchPanelWidget extends ConsumerWidget {
  const SearchPanelWidget({
    Key? key,
    this.initSearchText,
    required this.onSearch,
    this.tagsSort = false,
    this.tagsFilter = false,
  }) : super(key: key);
  final String? initSearchText;
  final Function(String) onSearch;
  final bool tagsSort;
  final bool tagsFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20, width: 20),
            Flexible(
                child: TextFieldWithClearButton(
              initText: initSearchText,
              onChanged: onSearch,
            )),
            if (tagsSort)
              DropdownButton<TagsSortOption>(
                  value: ref.watch(tagsSortOrder),
                  items: TagsSortOption.values.map((e) {
                    final str = e.toString();
                    final lable = str.substring(str.lastIndexOf('.') + 1);
                    return DropdownMenuItem(value: e, child: Text(lable));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(tagsSortOrder.notifier).update((state) => val);
                    }
                  }),
            if (tagsFilter)
              IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.filter_alt_outlined))
          ],
        ),
      ),
    );
  }
}

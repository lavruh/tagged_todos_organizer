import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/dropdownbutton_args.dart';

class SearchPanelWidget extends ConsumerWidget {
  const SearchPanelWidget({
    Key? key,
    required this.onSearch,
    this.buttonArgs,
  }) : super(key: key);
  final Function(String) onSearch;
  final DropDownButtonArgs? buttonArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white70,
      child: ListTile(
        title: TextField(
            onChanged: onSearch,
            decoration: const InputDecoration(
              labelText: 'Search',
              icon: Icon(Icons.filter_alt),
            )),
        trailing: buttonArgs != null
            ? DropdownButton(
                value: buttonArgs!.value,
                items: buttonArgs!.items.map((e) {
                  final str = e.toString();
                  final lable = str.substring(str.lastIndexOf('.') + 1);
                  return DropdownMenuItem(value: e, child: Text(lable));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    buttonArgs!.callback(val);
                  }
                })
            : null,
      ),
    );
  }
}

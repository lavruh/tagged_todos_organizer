import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/dropdownbutton_args.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_clear_button.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          title: TextFieldWithClearButton(onChanged: onSearch),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class UsedPartWidget extends StatelessWidget {
  const UsedPartWidget({
    super.key,
    required this.item,
    required this.update,
    required this.updateMaximoNo,
    this.delete,
  });
  final UsedPart item;
  final Function(UsedPart) update;
  final Function(UsedPart) updateMaximoNo;
  final Function? delete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        if (delete != null)
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (_) {
              if (delete != null) {
                delete!();
              }
            },
          )
      ]),
      child: Card(
          child: Row(children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFieldWithConfirm(
                text: item.maximoNumber,
                key: Key(item.maximoNumber),
                label: 'Maximo',
                maxLines: 1,
                keyboardType: TextInputType.number,
                onConfirm: (val) {
                  updateMaximoNo(item.copyWith(maximoNumber: val));
                }),
          ),
        ),
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFieldWithConfirm(
                  text: item.name,
                  key: Key(item.maximoNumber),
                  label: 'name',
                  onConfirm: (val) {
                    update(item.copyWith(name: val));
                  }),
            )),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFieldWithConfirm(
                text: item.bin,
                key: Key(item.maximoNumber),
                label: 'bin',
                maxLines: 1,
                onConfirm: (val) {
                  update(item.copyWith(bin: val));
                }),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: TextEditingController(text: item.pieces.toString()),
              key: Key(item.maximoNumber),
              decoration: InputDecoration(labelText: 'Qty'),
              maxLines: 1,
              keyboardType: TextInputType.number,
              onSubmitted: (val) {
                final n = int.tryParse(val);
                if (n != null) {
                  update(item.copyWith(pieces: n));
                }
              },
            ),
          ),
        ),
      ])),
    );
  }
}

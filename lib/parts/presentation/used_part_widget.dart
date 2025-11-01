import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';

class UsedPartWidget extends StatelessWidget {
  const UsedPartWidget({
    super.key,
    required this.item,
    required this.update,
    required this.updateMaximoNo,
    required this.updateCatalogNo,
    this.delete,
  });
  final UsedPart item;
  final Function(UsedPart) update;
  final Function(UsedPart) updateMaximoNo;
  final Function(UsedPart) updateCatalogNo;
  final Function? delete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          if (delete != null)
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (_) => delete?.call(),
            )
        ]),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AutoSizeTextField(
                            controller:
                                TextEditingController(text: item.maximoNumber),
                            key: Key(item.maximoNumber),
                            decoration: InputDecoration(labelText: 'Maximo'),
                            minFontSize: 8,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onSubmitted: (val) => updateMaximoNo(
                                item.copyWith(maximoNumber: val))),
                      ),
                    ),
                    Flexible(
                        flex: 10,
                        child: Text(
                            "${item.name}\ncat:${item.catalogNo}\nbin:${item.bin}")),
                  ],
                ),
              ),
              Container(),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller:
                          TextEditingController(text: item.pieces.toString()),
                      decoration: InputDecoration(labelText: 'Qty'),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onSubmitted: (val) {
                        final n = int.tryParse(val);
                        if (n != null) {
                          update(item.copyWith(pieces: n));
                        }
                      },
                    ),
                  ))
            ],
          ),
        ));
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_editor_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';

class UsedPartsEditScreen extends ConsumerStatefulWidget {
  const UsedPartsEditScreen({super.key});

  @override
  ConsumerState<UsedPartsEditScreen> createState() =>
      _UsedPartsEditScreenState();
}

class _UsedPartsEditScreenState extends ConsumerState<UsedPartsEditScreen> {
  static const inputTextStyle = TextStyle(fontSize: 12);

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(partsEditorProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => _exportToFile(context),
              icon: const Icon(Icons.download)),
          IconButton(
              onPressed: () => ref.read(partsEditorProvider.notifier).addPart(),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: DataTable2(
        columnSpacing: 2,
        columns: _generateHeader(),
        rows: <DataRow>[
          ...items.map((e) {
            final idx = items.indexOf(e);
            return usedPartWidget(e, idx);
          }),
        ],
      ),
    );
  }

  DataRow usedPartWidget(UsedPart item, int idx) {
    final state = ref.read(partsEditorProvider.notifier);

    return DataRow2(
      cells: <DataCell>[
        DataCell(AutoSizeTextField(
          controller: TextEditingController(text: item.maximoNumber),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onSubmitted: (v) => state.updatePartWithMaximoNo(
              part: item.copyWith(maximoNumber: v), index: idx),
        )),
        DataCell(AutoSizeTextField(
          controller: TextEditingController(text: item.catalogNo),
          textAlign: TextAlign.center,
          style: inputTextStyle,
          keyboardType: TextInputType.number,
          onSubmitted: (v) => state.updatePartWithCatalogNo(
              part: item.copyWith(catalogNo: v), index: idx),
        )),
        DataCell(AutoSizeTextField(
          controller: TextEditingController(text: item.name),
          minFontSize: 9,
          onSubmitted: (v) => state.updatePart(item.copyWith(name: v), idx),
        )),
        DataCell(AutoSizeTextField(
          controller: TextEditingController(text: item.bin),
          minFontSize: 9,
          style: inputTextStyle,
          onSubmitted: (v) => state.updatePart(item.copyWith(bin: v), idx),
        )),
        DataCell(AutoSizeTextField(
          controller: TextEditingController(text: item.pieces.toString()),
          textAlign: TextAlign.center,
          style: inputTextStyle,
          keyboardType: TextInputType.number,
          onSubmitted: (v) {
            final qty = int.tryParse(v);
            if (qty == null) return;
            state.updatePart(item.copyWith(pieces: qty), idx);
          },
        )),
      ],
    );
  }

  List<DataColumn> _generateHeader() {
    const headerStyle =
        TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

    return const <DataColumn>[
      DataColumn2(
        size: ColumnSize.M,
        label: Expanded(child: Text('Maximo', style: headerStyle)),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: Expanded(child: Text('PartNo', style: headerStyle)),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: Expanded(child: Text('Name', style: headerStyle)),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: Expanded(child: Text('Bin', style: headerStyle)),
      ),
      DataColumn2(
        size: ColumnSize.S,
        fixedWidth: 50,
        label: Expanded(child: Text('Qty', style: headerStyle)),
      ),
    ];
  }

  Future<void> _exportToFile(BuildContext context) async {
    final csvData =
        ref.read(partsEditorProvider.notifier).exportUsedPartsListToCsv();

    final result = await FilePicker.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'used_parts.csv',
      bytes: Uint8List.fromList(utf8.encode(csvData)),
      mimeType: 'text/csv',
    );

    if (result != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File exported successfully')));
      }
    }
  }
}

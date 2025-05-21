import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_data_picker/domain/data_picker_state.dart';
import 'package:photo_data_picker/ui/widget/data_picker_widget.dart';
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_editor_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';

class AddUsedPartScreen extends ConsumerStatefulWidget {
  const AddUsedPartScreen({super.key});

  @override
  ConsumerState<AddUsedPartScreen> createState() =>
      _CameraDataPickerScreenState();
}

class _CameraDataPickerScreenState extends ConsumerState<AddUsedPartScreen> {
  late DataPickerState state;
  final maximoInputController = TextEditingController();
  final qtyInputController = TextEditingController();
  Part? part;

  @override
  void initState() {
    super.initState();
    state = DataPickerState(
      onReadingChanged: updateMaximoNumber,
    );
    maximoInputController.text = state.reading;
    state.addListener(update);
  }

  updateMaximoNumber(String v) async {
    maximoInputController.text = v;
    part = await ref.read(partsInfoProvider).getPart(v);
    update();
  }

  @override
  void dispose() {
    state.dispose();
    state.disposeCamera();
    super.dispose();
  }

  update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: screenWidth * 0.95,
                  child: DataPickerWidget(
                    state: state,
                  ),
                ),
                if (part != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        "Name: ${part?.name}\nCatalog: ${part?.catalogNo}\nBin: ${part?.bin}"),
                  ),
                Row(
                  children: [
                    Flexible(
                      child: _Input(
                          textController: maximoInputController,
                          onConfirmPressed: () =>
                              updateMaximoNumber(maximoInputController.text),
                          label: 'Maximo Number'),
                    ),
                    Flexible(
                      child: _Input(
                          textController: qtyInputController,
                          onConfirmPressed: returnPart,
                          label: "Quantity used:"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void returnPart() {
    final p = part;
    final qty = int.tryParse(qtyInputController.text);
    if (p == null || qty == null) return;
    final usedPart = UsedPart.fromPart(part: p, qty: qty);
    ref.read(partsEditorProvider.notifier).addUsedPart(usedPart);
    if (mounted) context.pop();
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.textController,
    required this.onConfirmPressed,
  });
  final TextEditingController textController;
  final String label;
  final void Function() onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: textController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
            suffix: IconButton(
                tooltip: "Confirm",
                onPressed: onConfirmPressed,
                icon: Icon(Icons.check)),
          ),
        ));
  }
}

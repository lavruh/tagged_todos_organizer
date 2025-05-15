import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/utils/domain/string_extension.dart';

void main() {
  testWidgets('check and uncheck row in description',
      (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Row 1\nRow 2\nRow 3');
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TextField(controller: controller))));

    // Check Row 1
    controller.selection = const TextSelection.collapsed(offset: 1);
    var result = controller.value.checkRowUnderCursor();
    expect(result.text, '☐ Row 1\nRow 2\nRow 3');
    controller.value = result;

    // Uncheck Row 1
    controller.selection = const TextSelection.collapsed(offset: 1);
    result = controller.value.checkRowUnderCursor();
    expect(result.text, '☒ Row 1\nRow 2\nRow 3');
    controller.value = result;

    // Check Row 3 with cursor at the end
    controller.selection = const TextSelection.collapsed(offset: 15);
    result = controller.value.checkRowUnderCursor();
    expect(result.text, '☒ Row 1\nRow 2\n☐ Row 3');
    controller.value = result;

    // Uncheck Row 3 with cursor at the end
    controller.selection = const TextSelection.collapsed(offset: 15);
    result = controller.value.checkRowUnderCursor();
    expect(result.text, '☒ Row 1\nRow 2\n☒ Row 3');
    controller.value = result;
  });

  testWidgets('delete row under cursor', (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Row 1\nRow 2\nRow 3');
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TextField(controller: controller))));

    // Delete Row 2
    controller.selection = const TextSelection.collapsed(offset: 7);
    var result = controller.value.deleteRowUnderCursor();
    expect(result.text, 'Row 1\nRow 3');
    controller.value = result;

    // Delete Row 1
    controller.selection = const TextSelection.collapsed(offset: 0);
    result = controller.value.deleteRowUnderCursor();
    expect(result.text, '\nRow 3');
    controller.value = result;

    // Delete last row
    controller.selection = const TextSelection.collapsed(offset: 5);
    result = controller.value.deleteRowUnderCursor();
    expect(result.text, '');
    controller.value = result;
  });
}

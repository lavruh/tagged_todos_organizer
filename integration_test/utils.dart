
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'todo_editor_test.mocks.dart';


const testDirPath = "/home/lavruh/tmp/test/";

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<void> openDrawerMenu(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
}

void clearDirectory(String dir) {
  try {
    final d = Directory(p.join(testDirPath, dir));
    for (final entity in d.listSync()) {
      entity.deleteSync(recursive: true);
    }
  } on Exception {
    return;
  }
}

addNewTmpTodoAndEnterTitle(WidgetTester tester, String s) async {
  final addButton = find.byTooltip("Add tmp todo");
  expect(addButton, findsOneWidget);
  await tester.tap(addButton);
  await tester.pumpAndSettle();
  final input =
  find.descendant(of: find.byType(TextFormField), matching: find.text(""));
  expect(input, findsOneWidget);
  await tester.enterText(input, s);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.pumpAndSettle();
}

openOneDayView(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
  expect(find.text('One Day View'), findsOneWidget);
  await tester.tap(find.text('One Day View'));
  await tester.pumpAndSettle();
}


DateTime postponeDate(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

checkMenuItem(WidgetTester tester, String itemName, DateTime result) async {
  await tester.tap(find.byKey(const Key('todoPreviewDate')));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.text(itemName));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text(DateFormat('y-MM-dd').format(result)), findsOneWidget);
}

void checkDbUpdated(MockIDbService db) {
  verify(db.update(
      id: anyNamed('id'), item: anyNamed('item'), table: anyNamed('table')))
      .called(1);
}
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/utils/domain/string_extension.dart';

void main() {
  final row1 = "1123456789";
  final row2 = "2wertyuiop";
  final row3 = "3sdfghjkl;";
  final row4 = "4123456789";
  final input = "$row1\n$row2\n$row3\n$row4";

  tearDown(() async {});

  test('find row under cursor in mid row', () async {
    expect(input.getRowUnderCursor(row1.length + 1), contains(row2));
    expect(input.getRowUnderCursor(row1.length + 5), contains(row2));
    expect(input.getRowUnderCursor(row1.length + row2.length), contains(row2));
    expect(input.getRowUnderCursor(row1.length + row2.length + row3.length),
        contains(row3));
  });
  test('find row under cursor in beginning', () async {
    expect(input.getRowUnderCursor(0), contains(row1));
    expect(input.getRowUnderCursor(5), contains(row1));
    expect(input.getRowUnderCursor(row1.length), contains(row1));
  });
  test('find row under cursor in end', () async {
    final l3 = row1.length + row2.length + row3.length + 3;
    expect(input.getRowUnderCursor(l3 + 1), contains(row4));
    expect(input.getRowUnderCursor(l3 + 5), contains(row4));
    expect(input.getRowUnderCursor(l3 + row4.length), contains(row4));
  });
  test('row in single row line', () async {
    expect(row1.getRowUnderCursor(1), contains(row1));
    expect(row1.getRowUnderCursor(5), contains(row1));
    expect(row1.getRowUnderCursor(row1.length ), contains(row1));
  });

  test('get row offset from cursor', () async {
    expect(input.getRowUnderCursor(row1.length + 1), contains(row2));
    expect(input.getRowUnderCursor(row1.length + 5), contains(row2));
    expect(input.getRowUnderCursor(row1.length + row2.length), contains(row2));
    expect(input.getRowUnderCursor(row1.length + row2.length + row3.length),
        contains(row3));
  });
}

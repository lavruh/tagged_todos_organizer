import 'package:flutter/material.dart';

extension GetRowInPosition on String {
  String getRowUnderCursor(int cursorPosition) {
    final rows = split('\n');
    int startOfRow = 0;
    for (final s in rows) {
      final endOfRow = s.length + startOfRow + 1;
      if (startOfRow <= cursorPosition && endOfRow > cursorPosition) {
        startOfRow += s.length + 1;
        return s;
      }
      startOfRow += s.length + 1;
    }
    return "";
  }
}

extension TextEditingFunctions on TextEditingValue {
  TextEditingValue deleteRowUnderCursor() {
    final cursor = selection.start;
    final firstPart = text.substring(0, cursor);
    final endPart = text.substring(cursor);

    final firstEolIndex = endPart.indexOf("\n");
    final end = endPart.substring(firstEolIndex >= 0 ? firstEolIndex : 0);
    final lastEolIndex = firstPart.lastIndexOf('\n');
    final start = firstPart.substring(0, lastEolIndex >= 0 ? lastEolIndex : 0);

    final cursorPos = TextSelection.collapsed(offset: selection.start);
    if (lastEolIndex == -1) {
      return copyWith(
          text: end,
          selection: TextSelection.collapsed(
              offset: selection.start < 0 ? 0 : selection.start));
    }
    if (firstEolIndex == -1) {
      return copyWith(
        text: start,
        selection: TextSelection.collapsed(
            offset: selection.start > start.length
                ? start.length
                : selection.start),
      );
    }
    return copyWith(text: "$start$end", selection: cursorPos);
  }

  TextEditingValue checkRowUnderCursor() {
    final checked = Symbols.checked.symbol;
    final check = Symbols.unchecked.symbol;

    final selText = text.getRowUnderCursor(selection.start);
    final startSymbol = selText[0];
    String updatedString = "";
    if (startSymbol != check || startSymbol != checked) {
      updatedString = "$check $selText";
    }
    if (startSymbol == check) {
      updatedString = selText.replaceFirst(check, checked);
    }
    if (startSymbol == checked) {
      updatedString = selText.replaceFirst(checked, check);
    }
    final r = text.replaceFirst(selText, updatedString);
    return copyWith(
      text: r,
      selection: TextSelection.collapsed(offset: selection.start),
    );
  }

  TextEditingValue customEnterHandler() {
    final cursorPosition = selection.baseOffset;

    final frontText = text.substring(0, cursorPosition);
    final prevRow = frontText.split("\n").last;
    String insert = "\n";

    final afterText = text.substring(cursorPosition);
    if (prevRow.contains(Symbols.checked.symbol) ||
        prevRow.contains(Symbols.unchecked.symbol)) {
      insert += Symbols.unchecked.symbol;
    }

    final newCursorPosition = cursorPosition + insert.length;
    return copyWith(
      text: "$frontText$insert$afterText",
      selection: TextSelection.collapsed(
          offset: newCursorPosition, affinity: TextAffinity.downstream),
    );
  }
}

enum Symbols {
  checked,
  unchecked,
}

extension CheckboxStateExtension on Symbols {
  String get symbol {
    switch (this) {
      case Symbols.checked:
        return '☒';
      case Symbols.unchecked:
        return '☐';
    }
  }
}

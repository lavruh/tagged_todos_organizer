import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/app.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

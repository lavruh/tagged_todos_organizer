import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/presentation/widgets/log_entry_widget.dart';

class LogOverviewScreen extends ConsumerWidget {
  const LogOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(logProvider).reversed;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: items.map((e) => LogEntryWidget(entry: e)).toList(),
      ),
    );
  }
}

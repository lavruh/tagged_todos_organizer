import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/one_day_view_provider.dart';

class OneDayViewWidget extends ConsumerWidget {
  const OneDayViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(oneDayViewProvider);
    return ListView(
      key: Key(items.length.toString()),
      children: items,
    );
  }
}

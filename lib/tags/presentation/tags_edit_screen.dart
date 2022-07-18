import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';

class TagsEditScreen extends ConsumerWidget {
  const TagsEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => ref.read(tagsProvider.notifier).addTag(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Text('${ref.watch(tagsProvider)}'),
    );
  }
}

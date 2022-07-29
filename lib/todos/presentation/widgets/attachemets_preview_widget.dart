import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachementsPreviewWidget extends ConsumerWidget {
  const AttachementsPreviewWidget({Key? key, required this.items})
      : super(key: key);
  final List<String> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
        children: items
            .map((e) => TextButton(
                  onPressed: () async {
                    if (Platform.isLinux) {
                      final shell = Shell();
                      shell.run("xdg-open '$e'");
                    }
                    if (Platform.isAndroid) {
                      OpenFilex.open(e);
                    }
                  },
                  child: Text(p.basename(e)),
                ))
            .toList());
  }
}

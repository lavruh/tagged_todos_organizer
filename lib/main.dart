import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';

late final String appRootPath;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await isPermissionsGranted()) {
    final prefs = await SharedPreferences.getInstance();
    appRootPath = prefs.getString('appPath') ?? getAppFolderPath();
    prefs.setString('appPath', appRootPath);
    runApp(
      const RestartWidget(
        child: ProviderScope(
          child: MyApp(),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});
  final Widget child;

  static void updateRootPathAndRestartApp(
      BuildContext context, String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appPath', path);
    if (context.mounted) {
      context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();
    }
  }

  @override
  RestartWidgetState createState() {
    return RestartWidgetState();
  }
}

class RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  bool restartRequired = false;

  void restartApp() {
    setState(() {
      restartRequired = true;
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: restartRequired
          ? const Directionality(
              textDirection: TextDirection.ltr,
              child: Scaffold(
                body: Center(
                  child: Text('To force changes restart App...'),
                ),
              ),
            )
          : widget.child,
    );
  }
}

Future<bool> isPermissionsGranted() async {
  bool fl = true;
  if (Platform.isLinux) return true;
  int v = await getAndroidVersion() ?? 5;
  if (v >= 12) {
    // Request of this permission on old devices leads to crash
    if (fl && await Permission.manageExternalStorage.status.isDenied) {
      fl = await Permission.manageExternalStorage.request().isGranted;
    }
  } else {
    if (fl && await Permission.storage.status.isDenied) {
      fl = await Permission.storage.request().isGranted;
    }
  }
  if (fl && await Permission.camera.status.isDenied) {
    fl = await Permission.camera.request().isGranted;
  }
  if (fl && await Permission.microphone.status.isDenied) {
    fl = await Permission.microphone.request().isGranted;
  }
  return fl;
}

Future<int?> getAndroidVersion() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = androidInfo.version.release;
    return int.parse(androidVersion.split('.')[0]);
  }
  return null;
}

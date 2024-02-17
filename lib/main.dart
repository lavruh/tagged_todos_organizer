import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';

late final String appRootPath;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

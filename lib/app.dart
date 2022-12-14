import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_data_picker/ui/screen/camera_screen.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/image_view_screen.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const TodosScreen();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'TodoEditorScreen',
            builder: (context, state) {
              return const TodoEditScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'ImagesViewScreen',
                builder: (context, state) {
                  return const ImagesViewScreen();
                },
              ),
              GoRoute(
                path: 'CameraScreen',
                builder: (context, state) {
                  return CameraScreen();
                },
              ),
            ]),
        GoRoute(
            path: 'TagsEditScreen',
            builder: (context, state) {
              return const TagsEditScreen();
            }),
      ]),
]);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}

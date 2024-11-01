import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_data_picker/ui/photo_data_picker.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/image_view_screen.dart';
import 'package:tagged_todos_organizer/log/presentation/log_overview_screen.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/screens/one_day_view_screen.dart';
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
                  return const PhotoDataPicker();
                },
              ),
            ]),
        GoRoute(
            path: 'TagsEditScreen',
            builder: (context, state) {
              return const TagsEditScreen();
            }),
        GoRoute(
            path: 'LogOverviewScreen',
            builder: (context, state) {
              return const LogOverviewScreen();
            }),
        GoRoute(
            path: 'OneDayViewScreen',
            builder: (context, state) {
              return const OneDayViewScreen();
            }),
      ]),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}

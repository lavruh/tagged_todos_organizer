import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/image_view_screen.dart';
import 'package:tagged_todos_organizer/log/presentation/log_overview_screen.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/screens/one_day_view_screen.dart';
import 'package:tagged_todos_organizer/parts/presentation/add_used_part_screen.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_aliases_edit_screen.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/presentation/screens/camere_screen.dart';

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
                path: 'AddUsedPartScreen',
                builder: (context, state) {
                  return const AddUsedPartScreen();
                },
              ),
              GoRoute(
                path: 'PhotoAddScreen',
                builder: (context, state) {
                  return ImageAddScreen();
                },
              ),
            ]),
        GoRoute(
            path: 'TagsEditScreen',
            builder: (context, state) {
              return const TagsEditScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'TagsAliasesEditScreen',
                builder: (context, state) {
                  return const TagsAliasesEditScreen();
                },
              ),
            ]),
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

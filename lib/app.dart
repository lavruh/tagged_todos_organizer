import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/image_view_screen.dart';
import 'package:tagged_todos_organizer/log/presentation/log_overview_screen.dart';
import 'package:tagged_todos_organizer/one_day_view/presentation/screens/one_day_view_screen.dart';
import 'package:tagged_todos_organizer/parts/presentation/add_used_part_screen.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_parts_edit_screen.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_aliases_edit_screen.dart';
import 'package:tagged_todos_organizer/tags/presentation/tags_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_edit_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';
import 'package:tagged_todos_organizer/utils/presentation/screens/camere_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => _router);

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const OneDayViewScreen(),
    routes: [
      GoRoute(
          path: 'TagsEditScreen',
          builder: (context, state) => const TagsEditScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'TagsAliasesEditScreen',
              builder: (context, state) => const TagsAliasesEditScreen(),
            ),
          ]),
      GoRoute(
          path: 'LogOverviewScreen',
          builder: (context, state) => const LogOverviewScreen()),
      GoRoute(
        path: 'TodosScreen',
        builder: (context, state) => const TodosScreen(),
      ),
      GoRoute(
          path: 'TodoEditorScreen',
          builder: (context, state) => const TodoEditScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'ImagesViewScreen',
              builder: (context, state) => const ImagesViewScreen(),
            ),
            GoRoute(
              path: 'AddUsedPartScreen',
              builder: (context, state) => const AddUsedPartScreen(),
            ),
            GoRoute(
              path: 'UsedPartsEditScreen',
              builder: (context, state) => const UsedPartsEditScreen(),
            ),
            GoRoute(
              path: 'PhotoAddScreen',
              builder: (context, state) => ImageAddScreen(),
            ),
          ]),
    ],
  ),
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

import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todos_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tagged todos organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodosScreen(),
    );
  }
}

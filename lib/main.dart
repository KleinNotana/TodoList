import 'package:flutter/material.dart';
import 'package:todolist/screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 195, 65, 65)),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


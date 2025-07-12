import 'package:class_management/provider/class_provider.dart';
import 'package:class_management/screens/class_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ClassProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Manager',
      debugShowCheckedModeBanner: false,
      home: const ClassScreen(), 
    );
  }
}
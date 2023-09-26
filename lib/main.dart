// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:projeto_tcc/screens/splash_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Importante ao usar async/await no main.
  await DatabaseHelper.instance.database; // Inicialize o DatabaseHelper.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

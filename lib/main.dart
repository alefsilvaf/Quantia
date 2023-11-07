import 'package:flutter/material.dart';
import 'package:projeto_tcc/screens/splash_screen.dart';
import 'database/database_helper.dart';
import 'utils/seeders.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataBase = await DatabaseHelper.instance.database;
  final seeder = DatabaseSeeder(dataBase);
  await seeder.seedData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      theme: ThemeData(
        primaryColor: Color(0xFF6D6AFC),
        appBarTheme: AppBarTheme(
          color: Color(0xFF6D6AFC),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF6D6AFC), // Cor de fundo dos botões
          textTheme: ButtonTextTheme.primary, // Cor do texto
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D6AFC), // Define a cor de fundo padrão
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'), // Português do Brasil
      ],
      home: SplashScreen(),
    );
  }
}

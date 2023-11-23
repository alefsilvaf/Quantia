import 'package:flutter/material.dart';
import 'package:projeto_tcc/database/capital_transaction_database.dart';
import 'package:projeto_tcc/database/sale_database.dart';
import 'package:projeto_tcc/screens/splash_screen.dart';
import 'database/customer_database.dart';
import 'database/database_helper.dart';
import 'database/product_category_database.dart';
import 'database/product_database.dart';
import 'database/supplier_database.dart';
import 'database/user_database.dart';
import 'utils/seeders.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataBase = await DatabaseHelper.instance.database;
  final seeder = DatabaseSeeder(dataBase);
  await createTablesIfNotExists(); // Chama a função para criar as tabelas
  await seeder.seedData();
  runApp(MyApp());
}

Future<void> createTablesIfNotExists() async {
  final userDatabase = UserDatabase.instance;
  await userDatabase.createUserTableIfNotExists();

  final capitalTransactionDatabase = CapitalTransactionDatabase.instance;
  await capitalTransactionDatabase.createCapitalTransactionTableIfNotExists();

  final custommerDatabase = CustomerDatabase.instance;
  await custommerDatabase.createCustomerTableIfNotExists();

  final productDatabase = ProductDatabase.instance;
  await productDatabase.createProductTableIfNotExists();

  final productCategoryDatabase = ProductCategoryDatabase.instance;
  await productCategoryDatabase.createProductCategoryTableIfNotExists();

  final supplierDatabase = SupplierDatabase.instance;
  await supplierDatabase.createSupplierTableIfNotExists();

  final saleDatabase = SaleDatabase.instance;
  await saleDatabase.createSaleTableIfNotExists();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      debugShowCheckedModeBanner: false,
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

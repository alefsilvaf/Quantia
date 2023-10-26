// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'inventory.db');

    // Abre o banco de dados.
    return await openDatabase(
      path,
      // Deixar a versão como 1 e o onCreate como nulo para criar as tabelas posteriormente
      version: 1,
      onCreate: null,
    );
  }

  // Método para criar uma tabela no banco de dados.
  Future<void> createTable(String tableName, List<String> columns) async {
    final db = await instance.database;
    final columnsString = columns.join(', ');
    await db.execute('''
      CREATE TABLE $tableName (
        $columnsString
      )
    ''');
  }
}

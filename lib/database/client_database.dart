// ignore_for_file: prefer_const_declarations

import 'database_helper.dart';
import 'database_utils.dart';

class ClientDatabase {
  static final ClientDatabase instance = ClientDatabase._privateConstructor();
  static final String tableName = 'clients';

  ClientDatabase._privateConstructor();

  Future<void> createClientTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          name TEXT,
          address TEXT,
          phoneNumber TEXT
        )
      ''');
    }
  }

  Future<int> insertClient(Map<String, dynamic> client) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, client);
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }
}

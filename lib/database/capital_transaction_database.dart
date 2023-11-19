import '../models/CapitalTransactionModel.dart';
import 'database_helper.dart';
import 'database_utils.dart';

class CapitalTransactionDatabase {
  static final CapitalTransactionDatabase instance =
      CapitalTransactionDatabase._privateConstructor();
  static const String tableName = 'capital_transactions';

  CapitalTransactionDatabase._privateConstructor();

  Future<void> createCapitalTransactionTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY AUTOINCREMENT',
        'transaction_type INTEGER',
        'description TEXT',
        'amount REAL NOT NULL',
        'transaction_date TEXT NOT NULL',
      ]);
    }
  }

  Future<int> insertCapitalTransaction(Map<String, dynamic> transaction) async {
    await createCapitalTransactionTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, transaction);
  }

  Future<List<Map<String, dynamic>>> getCapitalTransactions() async {
    await createCapitalTransactionTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<int> deleteCapitalTransaction(int? id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CapitalTransactionModel>> getCapitalTransactionsByDateRange(
      String startDate, String endDate) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(tableName,
        where: 'transaction_date >= ? AND transaction_date <= ?',
        whereArgs: [startDate, endDate]);

    final transactions = <CapitalTransactionModel>[];
    for (var row in result) {
      transactions.add(CapitalTransactionModel.fromMap(row));
    }
    return transactions;
  }
}

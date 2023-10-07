import 'database_helper.dart';
import 'database_utils.dart';

class SaleDatabase {
  static final SaleDatabase instance = SaleDatabase._privateConstructor();
  static const String tableName = 'sales';

  SaleDatabase._privateConstructor();

  Future<void> createSaleTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'customer_id INTEGER NOT NULL',
        'products TEXT NOT NULL',
        'total_price REAL NOT NULL',
        'sale_date TEXT NOT NULL',
      ]);
    }
  }

  Future<int> insertSale(Map<String, dynamic> sale) async {
    createSaleTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, sale);
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getSaleById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final sales = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return sales.isNotEmpty ? sales.first : null;
  }

  Future<int> updateSale(Map<String, dynamic> sale) async {
    final db = await DatabaseHelper.instance.database;
    return await db
        .update(tableName, sale, where: 'id = ?', whereArgs: [sale['id']]);
  }

  Future<int> deleteSale(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

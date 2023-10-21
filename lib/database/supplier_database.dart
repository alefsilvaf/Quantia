import 'database_helper.dart';
import 'database_utils.dart';

class SupplierDatabase {
  static final SupplierDatabase instance =
      SupplierDatabase._privateConstructor();
  static const String tableName = 'suppliers';

  SupplierDatabase._privateConstructor();

  Future<void> createSupplierTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'name TEXT NOT NULL',
        'email TEXT',
        'phone_number TEXT',
        'address TEXT',
      ]);
    }
  }

  Future<int> insertSupplier(Map<String, dynamic> supplier) async {
    createSupplierTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, supplier);
  }

  Future<List<Map<String, dynamic>>> getSuppliers() async {
    await createSupplierTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getSupplierById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final suppliers =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return suppliers.isNotEmpty ? suppliers.first : null;
  }

  Future<int> updateSupplier(Map<String, dynamic> supplier) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(tableName, supplier,
        where: 'id = ?', whereArgs: [supplier['id']]);
  }

  Future<int> deleteSupplier(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

import 'database_utils.dart';
import 'database_helper.dart';

class CustomerDatabase {
  static final CustomerDatabase instance =
      CustomerDatabase._privateConstructor();
  static const String tableName = 'customers';

  CustomerDatabase._privateConstructor();

  Future<void> createCustomerTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'name TEXT NOT NULL',
        'email TEXT NOT NULL',
        'phone_number TEXT',
        'address TEXT',
      ]);
    }
  }

  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    await createCustomerTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, customer);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    await createCustomerTableIfNotExists(); // Certifique-se de criar a tabela primeiro
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final customers =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return customers.isNotEmpty ? customers.first : null;
  }

  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(tableName, customer,
        where: 'id = ?', whereArgs: [customer['id']]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCustomersByName(String query) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      tableName,
      where: 'name LIKE ?',
      whereArgs: ["%$query%"],
    );
  }
}

import 'database_helper.dart';
import 'database_utils.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._privateConstructor();
  static const String tableName = 'products';

  ProductDatabase._privateConstructor();

  Future<void> createProductTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'name TEXT NOT NULL',
        'description TEXT',
        'price REAL NOT NULL',
        'category_id INTEGER NOT NULL',
        'supplier_id INTEGER NOT NULL', // Adicione esta linha para o ID do fornecedor
      ]);
    }
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    await createProductTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    await createProductTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final products =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return products.isNotEmpty ? products.first : null;
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(tableName, product,
        where: 'id = ?', whereArgs: [product['id']]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

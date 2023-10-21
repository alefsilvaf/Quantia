import 'database_helper.dart';
import 'database_utils.dart';

class ProductCategoryDatabase {
  static final ProductCategoryDatabase instance =
      ProductCategoryDatabase._privateConstructor();
  static const String tableName = 'product_categories';

  ProductCategoryDatabase._privateConstructor();

  Future<void> createProductCategoryTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY',
        'name TEXT NOT NULL',
        'description TEXT',
      ]);
    }
  }

  Future<int> insertProductCategory(Map<String, dynamic> category) async {
    await createProductCategoryTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, category);
  }

  Future<List<Map<String, dynamic>>> getProductCategories() async {
    await createProductCategoryTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getProductCategoryById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final categories =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return categories.isNotEmpty ? categories.first : null;
  }

  Future<int> updateProductCategory(Map<String, dynamic> category) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(tableName, category,
        where: 'id = ?', whereArgs: [category['id']]);
  }

  Future<int> deleteProductCategory(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getProductCategoryByName(String name) async {
    final db = await DatabaseHelper.instance.database;
    final categories = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
    );

    return categories.isNotEmpty ? categories.first : null;
  }

  Future<Object?> getCategoryName(int categoryId) async {
    final db = await DatabaseHelper.instance.database;
    final categories = await db
        .query('product_categories', where: 'id = ?', whereArgs: [categoryId]);
    return categories.isNotEmpty ? categories.first['name'] : null;
  }
}

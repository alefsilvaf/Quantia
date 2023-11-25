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
        'quantity INTEGER',
        'category_id INTEGER',
        'supplier_id INTEGER', // Adicione esta linha para o ID do fornecedor
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

  Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
    await createProductTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      tableName,
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
    );
  }

  Future<List<Map<String, dynamic>>> searchAndFetchProductDetails(
      String searchTerm) async {
    await createProductTableIfNotExists();
    final db = await DatabaseHelper.instance.database;

    final sql = '''
    SELECT
      p.*,
      c.name AS category_name,
      s.name AS supplier_name
    FROM $tableName p
    LEFT JOIN product_categories c ON p.category_id = c.id
    LEFT JOIN suppliers s ON p.supplier_id = s.id
    WHERE p.name LIKE ? OR p.description LIKE ? OR c.name LIKE ? OR s.name LIKE ?
  ''';

    final searchTermPattern = '%$searchTerm%';

    return await db.rawQuery(sql, [
      searchTermPattern,
      searchTermPattern,
      searchTermPattern,
      searchTermPattern
    ]);
  }

  Future<void> updateProductQuantity(int productId, int newQuantity) async {
    final db = await DatabaseHelper.instance.database;

    await db.rawUpdate(
      'UPDATE $tableName SET quantity = ? WHERE id = ?',
      [newQuantity, productId],
    );
  }
}

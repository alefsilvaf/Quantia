import '../models/SaleModel.dart';
import 'database_helper.dart';
import 'database_utils.dart';

class SaleDatabase {
  static final SaleDatabase instance = SaleDatabase._privateConstructor();
  static const String tableName = 'sales';
  static const String saleItemsTable =
      'sale_items'; // Tabela para itens de venda

  SaleDatabase._privateConstructor();

  Future<void> createSaleTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    final tableExists = await DatabaseUtils.tableExists(db, tableName);

    if (!tableExists) {
      await DatabaseHelper.instance.createTable(tableName, [
        'id INTEGER PRIMARY KEY AUTOINCREMENT',
        'customer_id INTEGER NOT NULL',
        'total_price REAL NOT NULL',
        'is_credit INTEGER', // Adicione um campo para indicar se a venda é a crédito
        'payment_date TEXT',
        'due_date TEXT',
        'sale_date TEXT NOT NULL',
      ]);

      // Crie a tabela para itens de venda
      await DatabaseHelper.instance.createTable(saleItemsTable, [
        'id INTEGER PRIMARY KEY AUTOINCREMENT',
        'sale_id INTEGER NOT NULL', // Associação com a venda
        'product_id INTEGER NOT NULL', // ID do produto vendido
        'quantity REAL NOT NULL',
        'item_price REAL NOT NULL',
        'discount_item_price REAL', // Adicione um campo para desconto
      ]);
    }
  }

  Future<int> insertSale(Map<String, dynamic> sale) async {
    await createSaleTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, sale);
  }

  // Adicione esta função para inserir uma venda com desconto, crédito e data de pagamento
  Future<int> insertSaleWithDiscount(Map<String, dynamic> sale) async {
    await createSaleTableIfNotExists();
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

  Future<List<Map<String, dynamic>>> getSaleItems(int saleId) async {
    final db = await DatabaseHelper.instance.database;
    return await db
        .query(saleItemsTable, where: 'sale_id = ?', whereArgs: [saleId]);
  }

  Future<int> insertSaleItem(Map<String, dynamic> saleItem) async {
    await createSaleTableIfNotExists();
    final db = await DatabaseHelper.instance.database;
    return await db.insert(saleItemsTable, saleItem);
  }

  Future<List<Map<String, dynamic>>> getSalesWithoutCreditOption() async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    return await db.query(
      tableName,
      where: 'is_credit = ? AND sale_date between ? AND ? ',
      whereArgs: [0, startDate.toIso8601String(), endDate.toIso8601String()],
    );
  }

  Future<String> getCustomerNameBySale(Sale sale) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('''
    SELECT customers.name AS customer_name
    FROM sales
    INNER JOIN customers ON sales.customer_id = customers.id
    WHERE sales.id = ?
  ''', [sale.id]);

    return result.isNotEmpty ? result.first['customer_name'].toString() : '';
  }

  Future<List<Map<String, dynamic>>> getSalesCredito() async {
    final db = await DatabaseHelper.instance.database;
    return await db.rawQuery('''
    SELECT sales.*, customers.name AS customer_name
    FROM sales
    INNER JOIN customers ON sales.customer_id = customers.id
    WHERE sales.is_credit = 1 AND sales.payment_date is null
  ''');
  }
}

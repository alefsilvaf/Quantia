import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../database/customer_database.dart';
import '../database/product_category_database.dart';
import '../database/product_database.dart';
//import '../database/sale_database.dart';
import '../database/supplier_database.dart';

class DatabaseSeeder {
  final Database database;

  DatabaseSeeder(this.database);

  Future<void> seedData() async {
//final saleDatabase = SaleDatabase.instance;
//await saleDatabase.createSaleTableIfNotExists();
    final custommerDatabase = CustomerDatabase.instance;
    await custommerDatabase.createCustomerTableIfNotExists();
    final productDatabase = ProductDatabase.instance;
    await productDatabase.createProductTableIfNotExists();
    final productCategoryDatabase = ProductCategoryDatabase.instance;
    await productCategoryDatabase.createProductCategoryTableIfNotExists();
    final supplierDatabase = SupplierDatabase.instance;
    await supplierDatabase.createSupplierTableIfNotExists();
    await _seedCustomers();
    await _seedProducts();
    //await _seedSales();
    await _seedCategoryProducts();
    await _seedSuppliers();
  }

  Future<void> _seedCustomers() async {
    // Inserir clientes fictícios
    await database.insert('customers', {
      'name': 'Cliente 1',
      'email': 'cliente1@example.com',
      'phone_number': '35997010731'
    });
    await database.insert('customers', {
      'name': 'Cliente 2',
      'email': 'cliente2@example.com',
      'phone_number': '35997010731'
    });
    await database.insert('customers', {
      'name': 'Cliente 3',
      'email': 'cliente3@example.com',
      'phone_number': '35997010731'
    });
    await database.insert('customers', {
      'name': 'Cliente 4',
      'email': 'cliente4@example.com',
      'phone_number': '35997010731'
    });
    await database.insert('customers', {
      'name': 'Cliente 5',
      'email': 'cliente5@example.com',
      'phone_number': '35997010731'
    });
    // Adicione mais clientes conforme necessário
  }

  Future<void> _seedCategoryProducts() async {
    // Inserir produtos fictícios
    await database.insert('product_categories', {
      'name': 'Tipo 1',
      'description': 'Um produto, querida',
    });
    await database.insert('product_categories', {
      'name': 'Tipo 2',
      'description': 'Querida',
    });
    await database.insert('product_categories',
        {'name': 'Tipo 3', 'description': 'Um babadeiro, querida'});
    await database.insert('product_categories', {
      'name': 'Tipo 4',
      'description': 'Lorem sandkjasndkjnja',
    });
    await database.insert('product_categories', {
      'name': 'Tipo 5',
      'description': 'Megan TheStallion rainha do rap',
    });
    await database.insert('product_categories', {
      'name': 'Tipo 6',
      'description': 'Um produto babadeiro, querida',
    });
    // Adicione mais produtos conforme necessário
  }

  Future<void> _seedSuppliers() async {
    // Inserir produtos fictícios
    await database.insert('suppliers', {
      'name': 'Tipo 1',
      'phone_number': '35997010731',
    });
    await database.insert('suppliers', {
      'name': 'Tipo 2',
      'phone_number': '35997010731',
    });
    await database
        .insert('suppliers', {'name': 'Tipo 3', 'phone_number': '35997010731'});
    await database.insert('suppliers', {
      'name': 'Tipo 4',
      'phone_number': '35997010731',
    });

    // Adicione mais produtos conforme necessário
  }

  Future<void> _seedProducts() async {
    // Inserir produtos fictícios
    await database.insert(
        'products', {'name': 'Produto 1', 'price': 10.0, 'quantity': 0});
    await database.insert(
        'products', {'name': 'Produto 2', 'price': 20.0, 'quantity': 0});
    await database.insert(
        'products', {'name': 'Produto 3', 'price': 20.0, 'quantity': 0});
    await database.insert(
        'products', {'name': 'Produto 4', 'price': 20.0, 'quantity': 0});
    await database.insert(
        'products', {'name': 'Produto 5', 'price': 20.0, 'quantity': 0});
    await database.insert('products', {
      'name': 'Produto 6',
      'description': 'Um produto babadeiro, querida',
      'price': 20.0,
      'quantity': 0
    });
    // Adicione mais produtos conforme necessário
  }

  Future<void> _seedSales() async {
    // Inserir vendas fictícias
    await database.insert('sales', {
      'customer_id': 1, // ID do cliente fictício 1
      'total_price': 30.0,
      'sale_date': '2023-10-30T10:00:00',
    });
    await database.insert('sales', {
      'customer_id': 2, // ID do cliente fictício 2
      'total_price': 25.0,
      'sale_date': '2023-10-31T14:30:00',
    });
    // Adicione mais vendas conforme necessário
  }
}

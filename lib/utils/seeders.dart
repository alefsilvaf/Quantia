import 'package:path/path.dart';
import 'package:projeto_tcc/database/capital_transaction_database.dart';
import 'package:sqflite/sqflite.dart';

import '../database/customer_database.dart';
import '../database/product_category_database.dart';
import '../database/product_database.dart';
//import '../database/sale_database.dart';
import '../database/supplier_database.dart';
import 'EnumerableTansactionType.dart';

class DatabaseSeeder {
  final Database database;

  DatabaseSeeder(this.database);

  Future<void> seedData() async {
    await _seedCustomers();
    await _seedProducts();
    await _seedSales();
    await _seedCategoryProducts();
    await _seedSuppliers();
    await _seedCapitalTransactions();
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
      'is_credit': 0, // Exemplo de campo "isCredit" definido como false
      'payment_date': null, // Exemplo de campo "paymentDate" definido como null
      'due_date': null, // Exemplo de campo "dueDate" definido como null
    });
    await database.insert('sales', {
      'customer_id': 2, // ID do cliente fictício 2
      'total_price': 25.0,
      'sale_date': '2023-10-31T14:30:00',
      'is_credit': 0, // Exemplo de campo "isCredit" definido como false
      'payment_date': null, // Exemplo de campo "paymentDate" definido como null
      'due_date': null, // Exemplo de campo "dueDate" definido como null
    });
    // Adicione mais vendas conforme necessário
  }

  Future<void> _seedCapitalTransactions() async {
    // Inserir transações de capital fictícias
    await CapitalTransactionDatabase.instance
        .createCapitalTransactionTableIfNotExists();
    await database.insert('capital_transactions', {
      'transaction_type': TransactionType.Entrada.index,
      'description': 'Pão',
      'amount': 100.0,
      'transaction_date': '2023-11-05T15:30:00',
      // Outros campos relevantes, como descrição ou categoria, se aplicável.
    });
    await database.insert('capital_transactions', {
      'transaction_type': TransactionType.Saida.index,
      'description': 'Pão',
      'amount': 50.0,
      'transaction_date': '2023-11-06T10:15:00',
    });
    await database.insert('capital_transactions', {
      'transaction_type': TransactionType.Entrada.index,
      'description': 'Pão',
      'amount': 75.0,
      'transaction_date': '2023-11-07T14:45:00',
    });
    // Adicione mais transações conforme necessário.
  }
}

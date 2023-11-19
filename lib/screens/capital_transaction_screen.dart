import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tcc/database/customer_database.dart';
import 'package:projeto_tcc/screens/general_control_screen.dart';

import '../database/capital_transaction_database.dart';
import '../database/sale_database.dart';
import '../models/CapitalTransactionModel.dart';
import '../models/SaleModel.dart';
import '../models/TransactionInfoModel.dart';
import 'add_transaction_screen.dart';

class CapitalTransactionListScreen extends StatefulWidget {
  @override
  _CapitalTransactionListScreenState createState() =>
      _CapitalTransactionListScreenState();
}

class _CapitalTransactionListScreenState
    extends State<CapitalTransactionListScreen> {
  List<TransactionInfo> _transactions = [];
  final DateFormat _dateFormat = DateFormat('dd-MM-yy');
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    loadTransactionsAndSales();
  }

  Future<void> loadTransactionsAndSales() async {
    final startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final endDate = DateTime.now();

    final sales = await SaleDatabase.instance.getSalesWithoutCreditOption();
    final capitalTransactions = await CapitalTransactionDatabase.instance
        .getCapitalTransactionsByDateRange(
            startDate.toString(), endDate.toString());

    final transactions = capitalTransactions.map((transaction) {
      return TransactionInfo(
        id: transaction.id,
        description: transaction.description,
        amount: transaction.amount,
        transactionDate: DateTime.parse(transaction.transactionDate),
        transactionType: transaction.transactionType,
      );
    }).toList();

    for (final saleData in sales) {
      final sale = Sale.fromMapWithTotalPrice(saleData);
      var customerNameFinal =
          await SaleDatabase.instance.getCustomerNameBySale(sale);
      final saleAmount = sale.totalPrice;
      final saleDescription = "\nVenda feita para $customerNameFinal";

      transactions.add(TransactionInfo(
        id: 0, // Seu ID personalizado
        description: saleDescription,
        amount: saleAmount,
        transactionDate: sale.saleDate ??
            DateTime.now(), // Substitua pelo campo de data desejado
        transactionType: 0, // Substitua pelo tipo de transação desejado
      ));
    }

    transactions.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));

    setState(() {
      _transactions = transactions;
      this.totalIncome = _calculateTotalIncome();
      this.totalExpense = _calculateTotalExpense();
    });
  }

  double _calculateTotalIncome() {
    return _transactions
        .where((transaction) => transaction.transactionType == 0)
        .fold(0.0, (prev, curr) => prev + curr.amount);
  }

  double _calculateTotalExpense() {
    return _transactions
        .where((transaction) => transaction.transactionType == 1)
        .fold(0.0, (prev, curr) => prev + curr.amount);
  }

  _deleteTransaction(int? id) async {
    await CapitalTransactionDatabase.instance.deleteCapitalTransaction(id);

    // Remover a transação da lista _transactions
    _transactions.removeWhere((transaction) => transaction.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green, // Cor de fundo verde
        content: Center(
          child: Text(
            'Transação excluída com sucesso!',
            style: TextStyle(
              color: Colors.white, // Cor do texto branca
            ),
          ),
        ),
        duration: Duration(seconds: 2), // Ajuste a duração conforme necessário
      ),
    );

    setState(() {
      this.totalIncome = _calculateTotalIncome();
      this.totalExpense = _calculateTotalExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrada/Saída de Caixa')),
      body: Column(
        children: [
          Expanded(
            child: _transactions.isEmpty
                ? Center(child: Text('Nenhuma transação encontrada.'))
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];

                      Color cardColor = transaction.transactionType == 0
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2);
                      Color textColor = Colors.white;

                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8.0,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: cardColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tipo: ${transaction.transactionType == 0 ? 'Entrada' : 'Saída'}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Descrição: ${transaction.description}'),
                                              Text(
                                                  'Valor: R\$${transaction.amount.toStringAsFixed(2)}'),
                                              Text(
                                                  'Data: ${_dateFormat.format(transaction.transactionDate)}'),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: transaction.id != 0 &&
                                              transaction.id != null,
                                          child: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteTransaction(
                                                  transaction.id);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text('Total de Entradas: R\$${totalIncome.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Total de Saídas: R\$${totalExpense.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'Saldo Total: R\$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 25),
                  child: Text(
                    'Você está visualizando as transações do mês atual, caso queira visualizar de outras datas, acesse o relatório de Fluxo de Caixa',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                ).then((_) {
                  loadTransactionsAndSales();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D6AFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Registrar Entrada/Saída',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

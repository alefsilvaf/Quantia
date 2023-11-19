import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/capital_transaction_database.dart';
import '../../models/TransactionInfoModel.dart';

class CashFlowReportScreen extends StatefulWidget {
  @override
  _CashFlowReportScreenState createState() => _CashFlowReportScreenState();
}

class _CashFlowReportScreenState extends State<CashFlowReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<TransactionInfo> _transactions = [];
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await CapitalTransactionDatabase.instance
        .getCapitalTransactionsByDateRange(
            _startDate?.toString() ?? '', _endDate?.toString() ?? '');

    setState(() {
      _transactions = transactions.map((transaction) {
        return TransactionInfo(
          id: transaction.id,
          description: transaction.description,
          amount: transaction.amount,
          transactionDate: DateTime.parse(transaction.transactionDate),
          transactionType: transaction.transactionType,
        );
      }).toList();

      totalIncome = _calculateTotalIncome();
      totalExpense = _calculateTotalExpense();
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
      appBar: AppBar(title: Text('Relatório de Fluxo de Caixa')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selecione os filtros de data',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectStartDate,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Inicial'),
                ),
                ElevatedButton(
                  onPressed: _selectEndDate,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Final'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _loadTransactions,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 50),
              ),
              child: Text('Filtrar'),
            ),
          ),
          if (_startDate != null && _endDate != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Transações do período: ${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                                                  'Data: ${DateFormat('dd/MM/yyyy').format(transaction.transactionDate)}'),
                                            ],
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Total de Entradas: R\$${totalIncome.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Total de Saídas: R\$${totalExpense.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'Saldo Total: R\$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(Duration(days: 7)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }
}

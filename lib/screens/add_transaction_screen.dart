import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/capital_transaction_database.dart';
import '../models/CapitalTransactionModel.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  int _transactionType = 0; // 0 for entrada, 1 for saída

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: _transactionType,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('Entrada'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Saída'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _transactionType = value as int;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Transação',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Convertendo o valor do campo de valor para double
                double amount = double.tryParse(_amountController.text) ?? 0;

                // Criando uma instância da transação
                final transaction = {
                  'transaction_type': _transactionType,
                  'description': _descriptionController.text,
                  'amount': amount,
                  'transaction_date': _dateFormat.format(DateTime.now()),
                };

                // Salvando a transação no banco de dados
                await CapitalTransactionDatabase.instance
                    .insertCapitalTransaction(transaction);

                // Fechando a tela e retornando para a tela anterior
                Navigator.pop(context);
              },
              child: Text('Adicionar Transação'),
            ),
          ],
        ),
      ),
    );
  }
}

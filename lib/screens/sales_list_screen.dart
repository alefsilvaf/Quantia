import 'package:flutter/material.dart';

import '../database/sale_database.dart'; // Importe sua classe de banco de dados de vendas aqui

class SalesListScreen extends StatefulWidget {
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<Map<String, dynamic>> sales = []; // Lista para armazenar as vendas

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    final saleDatabase = SaleDatabase.instance;
    final loadedSales = await saleDatabase.getSales();

    setState(() {
      sales = loadedSales;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Vendas'),
      ),
      body: ListView.builder(
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];

          return ListTile(
            title: Text(
                'Venda #${sale['id']}'), // Personalize conforme sua estrutura de dados
            subtitle: Text(
                'Total: R\$${sale['total_price']} Data Venda: ${sale['sale_date']} Data Venda Prog: ${sale['due_date']}'),
            onTap: () {
              // Navegue para a tela de detalhes da venda ou realize a ação desejada
              // Você pode passar o ID da venda para a próxima tela se necessário
            },
          );
        },
      ),
    );
  }
}

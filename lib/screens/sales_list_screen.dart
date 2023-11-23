import 'package:flutter/material.dart';

import '../database/sale_database.dart';

class SalesListScreen extends StatefulWidget {
  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<Map<String, dynamic>> sales = [];

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  Future<void> loadSales() async {
    final saleDatabase = SaleDatabase.instance;
    final loadedSales = await saleDatabase.getSales();

    // Crie uma cópia mutável da lista antes de ordenar
    List<Map<String, dynamic>> mutableSales = List.from(loadedSales);

    // Ordenar as vendas em ordem decrescente pela data de venda
    mutableSales.sort((a, b) => b['sale_date'].compareTo(a['sale_date']));

    setState(() {
      sales = mutableSales;
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

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text('Venda #${sale['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total: R\$${sale['total_price']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Data Venda: ${sale['sale_date'] ?? 'Não informada'}'),
                  Text(
                      'Data Previsão Pagamento: ${sale['due_date'] ?? 'Não informada'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

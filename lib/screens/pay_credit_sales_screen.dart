import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/sale_database.dart';
import '../models/SaleModel.dart';

class PaySalesScreen extends StatefulWidget {
  @override
  _PaySalesScreenState createState() => _PaySalesScreenState();
}

class _PaySalesScreenState extends State<PaySalesScreen> {
  List<Sale> _salesFiado = [];

  @override
  void initState() {
    super.initState();
    _loadSalesFiado();
  }

  Future<void> _loadSalesFiado() async {
    final salesFiado = await SaleDatabase.instance.getSalesFiado();
    setState(() {
      _salesFiado = salesFiado.map((saleMap) {
        final sale = Sale.fromMapWithTotalPrice(saleMap);
        return sale;
      }).toList();
    });
  }

  Future<void> _markSaleAsPaid(Sale sale) async {
    // Atualize a lógica para marcar a venda como paga no banco de dados
    // Neste exemplo, estamos atualizando a data de vencimento para a data atual
    sale.paymentDate = DateTime.now();

    await SaleDatabase.instance.updateSale(sale.toMapWithoutCustomerName());

    // Recarregue as vendas fiado após a atualização para refletir as alterações na tela
    _loadSalesFiado();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Center(
          child: Text(
            'Transação excluída com sucesso!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baixas em Vendas Fiado')),
      body: _salesFiado.isEmpty
          ? Center(child: Text('Nenhuma venda fiado encontrada.'))
          : ListView.builder(
              itemCount: _salesFiado.length,
              itemBuilder: (context, index) {
                final sale = _salesFiado[index];
                final daysDifference =
                    sale.dueDate!.difference(DateTime.now()).inDays;
                final isOverdue = daysDifference < 0;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  child: ListTile(
                    title: Text('Cliente: ${sale.customerName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Valor: R\$${sale.totalPrice.toStringAsFixed(2)}'),
                        Text(
                            'Vencimento: ${DateFormat('dd/MM/yyyy').format(sale.dueDate!)}'),
                        if (isOverdue)
                          Text('Atrasado por: $daysDifference dias',
                              style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Marcar como Pago'),
                            content:
                                Text('Deseja marcar esta venda como paga?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _markSaleAsPaid(sale);
                                  Navigator.pop(context);
                                  _loadSalesFiado();
                                },
                                child: Text('Sim'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Pago'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

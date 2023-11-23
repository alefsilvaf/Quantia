import 'package:flutter/material.dart';

import '../general_control_screen.dart';
import 'cash_flow_screen.dart';
import 'due_sales_screens.dart';

class ReportsMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color customColor = Color(0xFF6D6AFC);

    return Scaffold(
      appBar: AppBar(title: Text('Relatórios')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: FuncionalidadeCard(
              titulo: 'Clientes em Dívida',
              icone: Icons.money_off,
              cor: customColor,
              rota: DueSalesReportScreen(),
            ),
          ),
          Expanded(
            child: FuncionalidadeCard(
              titulo: 'Fluxo de Caixa',
              icone: Icons.show_chart,
              cor: customColor,
              rota: CashFlowReportScreen(),
            ),
          ),
          // Expanded(
          //   child: FuncionalidadeCard(
          //     titulo: 'Produtos Mais Vendidos',
          //     icone: Icons.trending_up,
          //     cor: customColor,
          //     rota: ControleGeralScreen(),
          //   ),
          // ),
          // Expanded(
          //   child: FuncionalidadeCard(
          //     titulo: 'Clientes que Mais Compraram',
          //     icone: Icons.shopping_cart,
          //     cor: customColor,
          //     rota: ControleGeralScreen(),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class FuncionalidadeCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final Widget rota;

  FuncionalidadeCard({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => rota,
          ),
        );
      },
      child: Card(
        color: cor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icone,
                size: 48,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projeto_tcc/screens/product_output_sreen.dart';
import 'package:projeto_tcc/screens/reports/reports_screen.dart';
import 'capital_transaction_screen.dart';
import 'pay_credit_sales_screen.dart';
import 'product_category_screen.dart';
import 'product_list_screen.dart';
import 'sale_screen.dart';
import 'sales_list_screen.dart';
import 'supplier_list_screen.dart';
import 'user_registration_screen.dart';
import 'customer_list_screen.dart';

class ControleGeralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color customColor = Color(0xFF6D6AFC);

    return Scaffold(
      appBar: AppBar(
        title: Text('Controle Geral'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Duas colunas
          childAspectRatio: 1.0, // Tamanho 1:1 para cada quadrado
          mainAxisSpacing: 16.0, // Espaçamento vertical entre os quadros
          crossAxisSpacing: 16.0, // Espaçamento horizontal entre os quadros
          padding: EdgeInsets.all(16.0), // Espaçamento externo
          children: <Widget>[
            FuncionalidadeQuadro(
              titulo: 'Venda',
              icone: Icons.shopping_cart,
              cor: customColor,
              rota: SaleScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Baixa em Venda Fiado',
              icone: Icons.payment,
              cor: customColor,
              rota: PaySalesScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Entrada/Saída de Caixa',
              icone: Icons.account_balance_wallet,
              cor: customColor,
              rota: CapitalTransactionListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Produtos',
              icone: Icons.category,
              cor: customColor,
              rota: ProductListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Saída de Produtos',
              icone: Icons.outbond,
              cor: customColor,
              rota: ProductOutputScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Categoria de Produto',
              icone: Icons.storage,
              cor: customColor,
              rota: ProductCategoryScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Clientes',
              icone: Icons.person,
              cor: customColor,
              rota: CustomerListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Fornecedores',
              icone: Icons.group,
              cor: customColor,
              rota: SupplierListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Relatórios',
              icone: Icons.analytics,
              cor: customColor,
              rota: SalesListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Relatórios',
              icone: Icons.bar_chart,
              cor: customColor,
              rota: ReportsMenuScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class FuncionalidadeQuadro extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final Widget rota;

  FuncionalidadeQuadro({
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
      child: Container(
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o título
          children: <Widget>[
            Icon(
              icone,
              size: 48, // Tamanho do ícone
              color: Colors.white, // Cor do ícone
            ),
            SizedBox(height: 8),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Alinha o texto ao centro
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'product_category_screen.dart';
import 'product_list_screen.dart';
import 'product_registration_screen.dart';
import 'suplier_screen.dart';
import 'user_registration_screen.dart';
import 'customer_list_screen.dart';

class ControleGeralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              icone: Icons.person,
              cor: Colors.blue,
              rota: ControleGeralScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Produtos',
              icone: Icons.shopping_cart,
              cor: Colors.green,
              rota: ProductListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Clientes',
              icone: Icons.people,
              cor: Colors.orange,
              rota: CustomerListScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Relatórios',
              icone: Icons.receipt,
              cor: Colors.purple,
              rota: CadastroScreen(),
            ),
            FuncionalidadeQuadro(
              titulo: 'Fornecedores',
              icone: Icons.receipt,
              cor: Color.fromARGB(255, 24, 143, 20),
              rota: SupplierRegistrationScreen(),
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
            ),
          ],
        ),
      ),
    );
  }
}
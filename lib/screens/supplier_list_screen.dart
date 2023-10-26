import 'package:flutter/material.dart';
import '../database/supplier_database.dart';
import 'supplier_registration_screen.dart';

class SupplierListScreen extends StatefulWidget {
  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<Map<String, dynamic>> suppliers = [];

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  void _loadSuppliers() async {
    final existingSuppliers = await SupplierDatabase.instance.getSuppliers();
    setState(() {
      if (existingSuppliers != null) {
        suppliers = existingSuppliers;
      } else {
        suppliers = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fornecedores'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  child: ListTile(
                    title: Text(supplier['name']),
                    subtitle: Text(supplier['email'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SupplierRegistrationScreen(), // Substitua pelo nome da tela de cadastro de fornecedores
                ));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Cadastrar Fornecedor',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

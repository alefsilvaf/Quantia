import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../database/product_category_database.dart';
import '../database/product_database.dart';
import '../database/supplier_database.dart';

class ProductRegistrationScreen extends StatefulWidget {
  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  int _selectedCategoryId = 1; // Categoria padrão selecionada.
  int _selectedSupplierId = 1; // Fornecedor padrão selecionado.

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _refreshCategories();
    _refreshSuppliers();
  }

  _refreshCategories() async {
    var categories =
        await ProductCategoryDatabase.instance.getProductCategories();
    setState(() {
      _categories = categories;
    });
  }

  _refreshSuppliers() async {
    var suppliers = await SupplierDatabase.instance.getSuppliers();
    setState(() {
      _suppliers = suppliers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'O campo nome do produto não pode estar vazio.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(labelText: 'Descrição do Produto'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'O campo descrição do produto não pode estar vazio.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Preço do Produto',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'O campo preço do produto não pode estar vazio.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      // Remova vírgulas e pontos para analisar como número
                      double amount =
                          double.parse(value.replaceAll(RegExp(r'[^\d]'), '')) /
                              100;
                      _priceController.text = NumberFormat.currency(
                        locale: 'pt_BR',
                        symbol: 'R\$',
                        decimalDigits: 2,
                      ).format(amount);
                    }
                  },
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Categoria do Produto',
                  ),
                  child: DropdownButton<int>(
                    value: _selectedCategoryId,
                    items: _categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category['id'],
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value!;
                      });
                    },
                  ),
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fornecedor',
                  ),
                  child: DropdownButton<int>(
                    value: _selectedSupplierId,
                    items: _suppliers.map((supplier) {
                      return DropdownMenuItem<int>(
                        value: supplier['id'],
                        child: Text(supplier['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplierId = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> product = {
                        'name': _nameController.text,
                        'description': _descriptionController.text,
                        'price': double.parse(_priceController.text
                                .replaceAll(RegExp(r'[^\d]'), '')) /
                            100,
                        'category_id': _selectedCategoryId,
                        'supplier_id': _selectedSupplierId,
                      };
                      await ProductDatabase.instance.insertProduct(product);
                      Navigator.of(context)
                          .pop(); // Voltar para a tela anterior após o cadastro.
                    }
                  },
                  child: Text('Adicionar Produto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

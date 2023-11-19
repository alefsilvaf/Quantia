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
  final _quantityController =
      TextEditingController(); // Novo campo de quantidade
  int _selectedCategoryId = 0; // Categoria padrão selecionada.
  int _selectedSupplierId = 0; // Fornecedor padrão selecionado.

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

    // Converter a lista categories para o tipo correto
    var categoriesWithSelect = [
      {'id': 0, 'name': 'SELECIONE'},
      ...categories.map((category) {
        return {'id': category['id'], 'name': category['name']};
      })
    ];

    setState(() {
      _categories = categoriesWithSelect;
    });
  }

  _refreshSuppliers() async {
    var suppliers = await SupplierDatabase.instance.getSuppliers();

    // Converter a lista suppliers para o tipo correto
    var suppliersWithSelect = [
      {'id': 0, 'name': 'SELECIONE'},
      ...suppliers.map((supplier) {
        return {'id': supplier['id'], 'name': supplier['name']};
      })
    ];

    setState(() {
      _suppliers = suppliersWithSelect;
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
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('Quantidade: '),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        int quantity =
                            int.tryParse(_quantityController.text) ?? 0;
                        if (quantity > 0) {
                          setState(() {
                            quantity--;
                            _quantityController.text = quantity.toString();
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        int quantity =
                            int.tryParse(_quantityController.text) ?? 0;
                        setState(() {
                          quantity++;
                          _quantityController.text = quantity.toString();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 170.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
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
                            'quantity':
                                int.tryParse(_quantityController.text) ?? 0,
                          };

                          await ProductDatabase.instance.insertProduct(product);
                          Navigator.of(context)
                              .pop(); // Voltar para a tela anterior após o cadastro.
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Center(
                              child: Text(
                                'Produto adicionado com sucesso!',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text('Adicionar Produto'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

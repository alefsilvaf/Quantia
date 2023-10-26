import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../database/product_category_database.dart';
import '../database/product_database.dart';
import '../database/supplier_database.dart';
import '../models/ProductModel.dart'; // Certifique-se de importar o modelo correto.

class ProductEditScreen extends StatefulWidget {
  final ProductModel product;

  ProductEditScreen({required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  int _selectedCategoryId = 0;
  int _selectedSupplierId = 0;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _suppliers = [];

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = formatPrice(widget.product.price);
    _selectedCategoryId = widget.product.categoryId ?? 0;
    _selectedSupplierId = widget.product.supplierId ?? 0;

    _refreshCategories();
    _refreshSuppliers();
  }

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(price);
  }

  _refreshCategories() async {
    var categories =
        await ProductCategoryDatabase.instance.getProductCategories();
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
      appBar: AppBar(title: Text('Editar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Use o _formKey para validar o formulário.
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
                  decoration: InputDecoration(labelText: 'Preço do Produto'),
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
                  decoration:
                      InputDecoration(labelText: 'Categoria do Produto'),
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
                  decoration: InputDecoration(labelText: 'Fornecedor'),
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
                      final updatedName = _nameController.text;
                      final updatedDescription = _descriptionController.text;
                      final updatedPrice = double.parse(_priceController.text
                              .replaceAll(RegExp(r'[^\d]'), '')) /
                          100;

                      final updatedProduct = ProductModel(
                        id: widget.product.id,
                        name: updatedName,
                        description: updatedDescription,
                        price: updatedPrice,
                        categoryId: _selectedCategoryId,
                        supplierId: _selectedSupplierId,
                      );

                      _updateProduct(updatedProduct);

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateProduct(ProductModel updatedProduct) async {
    await ProductDatabase.instance.updateProduct(updatedProduct.toMap());
  }
}

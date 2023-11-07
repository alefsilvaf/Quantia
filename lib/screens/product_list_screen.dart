import 'package:flutter/material.dart';

import '../database/product_category_database.dart';
import '../database/product_database.dart';
import '../database/supplier_database.dart';
import '../models/ProductModel.dart';
import 'product_registration_screen.dart';
import 'product_edit_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  _refreshProductList() async {
    var products = await ProductDatabase.instance.getProducts();
    var updatedProducts = <ProductModel>[];

    for (var productMap in products) {
      var updatedProductMap = Map<String, dynamic>.from(productMap);

      final categoryId = productMap['category_id'];
      if (categoryId != null) {
        final categoryName =
            await ProductCategoryDatabase.instance.getCategoryName(categoryId);

        updatedProductMap['category_name'] = categoryName;
      }

      final supplierId = productMap['supplier_id'];
      if (supplierId != null) {
        final supplierName =
            await SupplierDatabase.instance.getSupplierName(supplierId);

        updatedProductMap['supplier_name'] = supplierName;
      }

      final productModel = ProductModel.fromMap(updatedProductMap);
      updatedProducts.add(productModel);
    }

    setState(() {
      _products = updatedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Produtos')),
      body: Column(
        children: [
          Expanded(
            child: _products.isEmpty
                ? Center(
                    child: Text('Nenhum produto cadastrado.'),
                  )
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.0, // Margens horizontais
                          vertical: 5.0, // Margens verticais
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _products[index].name.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            20.0, // Tamanho da fonte aumentado
                                      ),
                                    ),
                                    Text(
                                      'Descrição: ${_products[index].description}',
                                    ),
                                    Text('Preço: ${_products[index].price}'),
                                    Text(
                                      'Quantidade: ${_products[index].quantity != null && _products[index].quantity as int > 0 ? _products[index].quantity.toString() : '-'}',
                                    ),
                                    Text(
                                      'Categoria: ${_products[index].categoryName ?? 'Indefinida'}',
                                    ),
                                    Text(
                                      'Fornecedor: ${_products[index].supplierName ?? 'Indefinido'}',
                                    ),
                                  ],
                                ),
                              ),
                              _buildEditButton(index),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                  left: 45,
                  right: 45,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductRegistrationScreen(),
                  ),
                );
                _refreshProductList();
              },
              child: Text('Cadastrar Novo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(int index) {
    return InkWell(
      onTap: () {
        _editProduct(_products[index]);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit),
      ),
    );
  }

  void _editProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditScreen(product: product),
      ),
    ).then((_) {
      _refreshProductList();
    });
  }
}

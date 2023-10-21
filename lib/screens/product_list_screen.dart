import 'package:flutter/material.dart';

import '../database/product_category_database.dart';
import '../database/product_database.dart';
import '../models/ProductModel.dart';
import 'product_registration_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> _products = []; // Use a classe ProductModel

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  _refreshProductList() async {
    var products = await ProductDatabase.instance.getProducts();
    var updatedProducts = <ProductModel>[]; // Use uma lista de ProductModel

    for (var productMap in products) {
      final categoryId = productMap['category_id'];
      final categoryName = await getCategoryName(categoryId);
      final supplierId = productMap['supplier_id'];
      final supplierName = await getSupplierName(supplierId);

      final product = ProductModel(
        id: productMap['id'],
        name: productMap['name'],
        description: productMap['description'],
        price: productMap['price'],
        categoryId: categoryId,
        categoryName: categoryName,
        supplierId: supplierId,
        supplierName: supplierName,
      );

      updatedProducts.add(product);
    }

    setState(() {
      _products = updatedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Produtos')),
      body: _products.isEmpty
          ? Center(
              child: Text('Nenhum produto cadastrado.'),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      _products[index].name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descrição: ${_products[index].description}'),
                        Text('Preço: ${_products[index].price}'),
                        Text(
                            'Categoria: ${_products[index].categoryName}'), // Exibe o nome da categoria
                        Text(
                            'Fornecedor: ${_products[index].supplierName}'), // Exibe o nome do fornecedor
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductRegistrationScreen(),
            ),
          );

          // Atualize a lista de produtos quando voltar da tela de registro
          _refreshProductList();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String> getCategoryName(int categoryId) async {
    final categoryName =
        await ProductCategoryDatabase.instance.getCategoryName(categoryId);
    return categoryName.toString();
  }

  Future<String> getSupplierName(int supplierId) async {
    // Implemente a lógica para obter o nome do fornecedor a partir do fornecedorId
    return "Nome do Fornecedor"; // Substitua isso pela lógica real
  }
}

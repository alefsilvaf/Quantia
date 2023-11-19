import 'package:flutter/material.dart';
import '../database/product_database.dart';

class ProductOutputScreen extends StatefulWidget {
  @override
  _ProductOutputScreenState createState() => _ProductOutputScreenState();
}

class _ProductOutputScreenState extends State<ProductOutputScreen> {
  List<Map<String, dynamic>> _availableProducts = [];
  Map<String, dynamic>? _selectedProduct;
  TextEditingController _quantityController = TextEditingController();
  String _operationType = 'Saída';

  @override
  void initState() {
    super.initState();
    _loadAvailableProducts();
  }

  Future<void> _loadAvailableProducts() async {
    final products = await ProductDatabase.instance.getProducts();
    setState(() {
      if (_operationType == 'Saída') {
        _availableProducts =
            products.where((product) => product['quantity'] > 0).toList();
      } else {
        _availableProducts = products;

// Criar uma nova lista para armazenar os produtos filtrados e ordenar
        List<Map<String, dynamic>> sortedProducts =
            List.from(_availableProducts);

// Ordenar a nova lista por quantidade em ordem crescente
        sortedProducts.sort((a, b) => b['quantity'].compareTo(a['quantity']));

// Atualizar a lista _availableProducts com a lista ordenada
        setState(() {
          _availableProducts = sortedProducts;
        });
      }

      // Se a lista de produtos disponíveis não contém o produto selecionado, defina como null
      if (_selectedProduct != null &&
          !_availableProducts.contains(_selectedProduct)) {
        _selectedProduct = null;
      }
    });
  }

  Future<void> _confirmProductOperation() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecione um produto para registrar $_operationType.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int operationQuantity = int.tryParse(_quantityController.text) ?? 0;

    if (operationQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('A quantidade de $_operationType deve ser maior que zero.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int currentQuantity = _selectedProduct!['quantity'];

    if (_operationType == 'Saída' && operationQuantity > currentQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'A quantidade de $_operationType não pode ser maior que a quantidade disponível.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Atualize a quantidade no banco de dados
    int newQuantity;

    if (_operationType == 'Saída') {
      newQuantity = currentQuantity - operationQuantity;
    } else {
      newQuantity = currentQuantity + operationQuantity;
    }

    final updatedProduct = {..._selectedProduct!, 'quantity': newQuantity};
    await ProductDatabase.instance.updateProduct(updatedProduct);

    // Limpe o estado e os controladores após a atualização
    setState(() {
      _selectedProduct = null;
    });
    _quantityController.clear();

    // Exiba um aviso ou mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_operationType registrada com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Recarregue a lista de produtos disponíveis
    await _loadAvailableProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar $_operationType de Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _operationType,
              onChanged: (value) {
                setState(() {
                  _operationType = value!;
                  _loadAvailableProducts();
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'Saída',
                  child: Text('Registrar Saída'),
                ),
                DropdownMenuItem<String>(
                  value: 'Entrada',
                  child: Text('Registrar Entrada'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            DropdownButton<Map<String, dynamic>>(
              hint: Text('Selecione um produto'),
              value: _selectedProduct,
              onChanged: (product) {
                setState(() {
                  _selectedProduct = product;
                });
              },
              items: _availableProducts.map((product) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: product,
                  child: Text(
                      '${product['name']} - Quantidade Disponível: ${product['quantity']}'),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade de $_operationType',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _confirmProductOperation,
              child: Text('Registrar $_operationType'),
            ),
          ],
        ),
      ),
    );
  }
}

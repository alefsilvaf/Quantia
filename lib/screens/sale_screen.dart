import 'package:flutter/material.dart';
import '../database/customer_database.dart';
import '../database/product_database.dart';
import '../database/sale_database.dart';
import '../models/CustomerModel.dart';
import '../models/ProductModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../models/SaleModel.dart'; // Importe o pacote flutter_typeahead

class Product {
  int productId; // Propriedade para o ID do produto
  String name;
  String description;
  double price;
  int quantity;

  Product(
      this.productId, this.name, this.description, this.price, this.quantity);
}

class SaleScreen extends StatefulWidget {
  CustomerModel? selectedCustomer;

  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  bool isCredit = false;
  List<Product> products = [];
  List<CustomerModel> customers = [];
  TextEditingController _customerController =
      TextEditingController(); // Controller para a pesquisa de clientes
  List<Product> selectedProducts =
      []; // Lista para rastrear os produtos selecionados

  @override
  void initState() {
    super.initState();
    loadCustomersAndProducts();
  }

  Future<void> loadCustomersAndProducts() async {
    final loadedCustomers = await CustomerDatabase.instance.getCustomers();
    final loadedProducts = await ProductDatabase.instance.getProducts();

    setState(() {
      customers = loadedCustomers
          .map((customer) => CustomerModel.fromMap(customer))
          .toList();
      products = loadedProducts
          .map((product) => ProductModel.fromMap(product))
          .map((productModel) => Product(
                productModel.id,
                productModel.name,
                productModel.description,
                productModel.price,
                0,
              ))
          .toList();
    });
  }

  void updateSelectedProducts(Product product) {
    if (!selectedProducts.contains(product)) {
      selectedProducts.add(product);
    }
  }

  double getTotal() {
    double total = 0.0;
    for (final product in products) {
      total += product.price * product.quantity;
    }
    return total;
  }

  Widget buildCustomerDropdown() {
    // Criar um item com valor nulo para representar "Selecione"
    CustomerModel? defaultCustomer = null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Selecione o Cliente:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          buildCustomDropdown(
            value: widget.selectedCustomer ?? defaultCustomer,
            onChanged: (CustomerModel? newValue) {
              setState(() {
                widget.selectedCustomer = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildCustomDropdown({
    required CustomerModel? value,
    required ValueChanged<CustomerModel?> onChanged,
  }) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<CustomerModel>(
        value: value,
        onChanged: onChanged,
        items: customers.map<DropdownMenuItem<CustomerModel>>(
          (CustomerModel customer) {
            return DropdownMenuItem<CustomerModel>(
              value: customer,
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(customer.name),
                ),
              ),
            );
          },
        ).toList(),
        icon: Icon(Icons.arrow_drop_down),
        underline: SizedBox.shrink(),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              product.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${product.description}'),
            tileColor: Colors.blue[50],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPriceInput(product),
              buildQuantityControls(product),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total: R\$${(product.price * product.quantity).toStringAsFixed(2)}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceInput(Product product) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text('Preço: R\$'),
          SizedBox(
            width: 60,
            child: TextFormField(
              initialValue: product.price.toStringAsFixed(2),
              keyboardType: TextInputType.number,
              onChanged: (newValue) {
                setState(() {
                  product.price = double.tryParse(newValue) ?? 0.0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityControls(Product product) {
    return Row(
      children: [
        Text('Quantidade: '),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (product.quantity > 0) {
                product.quantity--;
              }
            });
          },
        ),
        Text(product.quantity.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              product.quantity++;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Venda'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 40, left: 25, right: 25, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Selecione o Cliente:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TypeAheadField<CustomerModel>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _customerController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar cliente',
                    ),
                    onTap: () {
                      // Limpe a caixa de texto quando o usuário tocar no dropdown
                      _customerController.clear();
                    },
                  ),
                  suggestionsCallback: (pattern) async {
                    // Retorna a lista de clientes que coincidem com o padrão de pesquisa
                    return customers.where((customer) => customer.name
                        .toLowerCase()
                        .contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, CustomerModel suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (CustomerModel? suggestion) {
                    setState(() {
                      widget.selectedCustomer = suggestion;
                      _customerController.text = suggestion!.name;
                    });
                  },
                ),
              ],
            ),
          ),
          Text(
            'Produtos', // Legenda para os cards de produtos
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return buildProductCard(product);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Venda Fiado'),
                    Checkbox(
                      value: isCredit,
                      onChanged: (value) {
                        setState(() {
                          isCredit = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Geral: R\$${getTotal().toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: () async {
                    // 1. Calcular o total da venda
                    double totalSalePrice = getTotal();

                    // 2. Criar uma instância da classe Sale
                    final sale = Sale(
                      id: 0, // O ID será gerado automaticamente no banco de dados
                      customerId: widget
                          .selectedCustomer!.id, // ID do cliente selecionado
                      totalPrice: totalSalePrice,
                      saleDate: DateTime.now(), // Use a data atual
                      isCredit:
                          isCredit, // Defina com base na seleção do usuário
                      dueDate: isCredit
                          ? DateTime.now().add(Duration(days: 30))
                          : null, // Defina a data de pagamento, se aplicável
                    );

                    // 3. Inserir a venda no banco de dados
                    final saleId =
                        await SaleDatabase.instance.insertSale(sale.toMap());

                    // Inserir os itens da venda no banco de dados
                    for (final product in selectedProducts) {
                      final saleItem = SaleItem(
                        id: 0, // O ID será gerado automaticamente no banco de dados
                        saleId: saleId,
                        productId: product.productId, // ID do produto vendido
                        quantity: product.quantity,
                        itemPrice: product.price,
                        discountItemPrice:
                            0.0, // Defina o desconto, se aplicável
                      );

                      await SaleDatabase.instance
                          .insertSaleItem(saleItem.toMap());
                    }

                    // Limpar a lista de produtos selecionados
                    selectedProducts.clear();

                    // Reinicializar o valor total
                    setState(() {
                      isCredit = false;
                    });

                    // Atualizar a interface do usuário, se necessário
                  },
                  child: Text('Finalizar Venda'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

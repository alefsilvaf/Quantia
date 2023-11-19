import 'dart:ffi';

import 'package:flutter/material.dart';
import '../database/customer_database.dart';
import '../database/product_database.dart';
import '../database/sale_database.dart';
import '../models/CustomerModel.dart';
import '../models/ProductModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/SaleModel.dart';
import '../utils/success_message.dart';

class SaleScreen extends StatefulWidget {
  CustomerModel? selectedCustomer;

  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  DateTime? dueDate;
  bool isDateSelected = false;

  int isCredit = 0;
  List<ProductModel> products = [];
  List<CustomerModel> customers = [];
  TextEditingController _customerController = TextEditingController();
  List<ProductModel> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    initializeProducts();
    initializeCustomers();
  }

  Future<void> initializeProducts() async {
    final loadedProducts = await loadProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  void updateSelectedProducts() {
    selectedProducts.clear();
    selectedProducts.addAll(products.where((product) => product.quantity > 0));
  }

  Future<void> initializeCustomers() async {
    customers = await loadCustomers();
  }

  Future<List<ProductModel>> loadProducts() async {
    final productData = await ProductDatabase.instance.getProducts();
    return productData
        .map((product) => ProductModel.fromMapWithoutQuantity(product))
        .toList();
  }

  Future<List<CustomerModel>> loadCustomers() async {
    final customerData = await CustomerDatabase.instance.getCustomers();
    return customerData
        .map((customer) => CustomerModel.fromMap(customer))
        .toList();
  }

  double getTotal() {
    double total = 0.0;
    for (final product in products) {
      total += product.price * product.quantity;
    }
    return total;
  }

  Widget buildCustomerDropdown() {
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
        border: Border.all(color: Color(0xFF6D6AFC)),
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

  Widget buildProductCard(ProductModel product) {
    return Card(
      key: ValueKey(
          product), // Adicione um ValueKey para garantir a reconstrução adequada

      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              product.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${product.description}'),
            tileColor: Color.fromARGB(61, 108, 106, 252),
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

  Widget buildPriceInput(ProductModel product) {
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

  Widget buildQuantityControls(ProductModel product) {
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
              updateSelectedProducts();
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
                    fontSize: 20.0,
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
                      _customerController.clear();
                    },
                  ),
                  suggestionsCallback: (pattern) async {
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
            'Produtos',
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
                SizedBox(height: 20.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Venda Fiado'),
                    Checkbox(
                      value: isCredit == 0 ? false : true,
                      onChanged: (value) {
                        setState(() {
                          isCredit = value! ? 1 : 0;
                        });
                      },
                    ),
                  ],
                ),
                if (isCredit ==
                    1) // Mostra o calendário se 'Venda Fiado' estiver marcado.
                  Column(
                    children: [
                      buildDatePicker(
                          context), // Chama a função que mostra o DatePicker.
                    ],
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.selectedCustomer == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Aviso'),
                            content: Text(
                                'Por favor, selecione um cliente para a venda.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (getTotal() <= 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Aviso'),
                            content: Text(
                                'Pelo menos um produto deve ser selecionado para efetuar a venda.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      double totalSalePrice = getTotal();

                      final sale = Sale(
                        customerId: widget.selectedCustomer!.id,
                        totalPrice: totalSalePrice,
                        saleDate: DateTime.now(),
                        isCredit: isCredit,
                        dueDate: dueDate,
                      );

                      final saleId = await SaleDatabase.instance
                          .insertSale(sale.toMapWithoutCustomerName());

                      for (final product in selectedProducts) {
                        final saleItem = SaleItem(
                          saleId: saleId,
                          productId: product.id,
                          quantity: product.quantity,
                          itemPrice: product.price,
                          discountItemPrice: 0.0,
                        );

                        await SaleDatabase.instance
                            .insertSaleItem(saleItem.toMap());
                      }

                      selectedProducts.clear();

                      setState(() {
                        isCredit = 0;
                      });

                      handleSaleCompletion();
                    }
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

  bool canCompleteSale() {
    return widget.selectedCustomer != null && getTotal() > 0.0;
  }

  void handleSaleCompletion() async {
    // Redirecionar o usuário para a tela de sucesso
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen()),
    );

    // Aguardar 2 segundos antes de redirecionar para a tela de controle geral
    await Future.delayed(Duration(seconds: 2));

    // Redirecionar o usuário para a tela de controle geral
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget buildDatePicker(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );

        if (selectedDate != null) {
          setState(() {
            dueDate = selectedDate;
            isDateSelected = true;
          });
        }
      },
      child: Text('Selecionar Data de Pagamento Prevista'),
    );
  }
}

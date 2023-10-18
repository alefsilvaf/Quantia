// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../database/customer_database.dart';
import 'customer_registration_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> _customers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    final customers = await CustomerDatabase.instance.getCustomers();
    setState(() {
      _customers =
          customers ?? []; // Inicializa como uma lista vazia se for nula
    });
  }

  void _searchCustomers(String query) async {
    if (query.trim().isNotEmpty) {
      // Verifica se a consulta (após remover espaços em branco) não está vazia
      final customers =
          await CustomerDatabase.instance.getCustomersByName(query);
      setState(() {
        _customers = customers;
      });
    } else {
      // Se a consulta estiver vazia, carregue todos os clientes
      _loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(35.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _searchCustomers(query
                      .trim()); // Use trim() para remover espaços em branco
                },
                decoration: InputDecoration(labelText: 'Pesquisar Cliente'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        customer['name'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text('Telefone: ${customer['phone_number']}'),
                          SizedBox(height: 8.0),
                          Text('E-mail: ${customer['email']}'),
                          SizedBox(height: 8.0),
                          Text('Endereço: ${customer['address']}'),
                          SizedBox(height: 8.0),
                        ],
                      ),
                      onLongPress: () {
                        // Copie os detalhes do cliente para a área de transferência
                        final customerDetails =
                            'Nome: ${customer['name']}\nTelefone: ${customer['phone_number']}\nE-mail: ${customer['email']}\nEndereço: ${customer['address']}';

                        Clipboard.setData(ClipboardData(text: customerDetails));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Detalhes copiados'),
                        ));
                      },
                      trailing: GestureDetector(
                        onTap: () async {
                          _launchWhatsapp('${customer['phone_number']}');
                        },
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 60.0, // Ajuste com base na altura do Card
                          width: 48.0, // Ajuste com base na altura do Card
                          child: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                            size:
                                35.0, // Ajuste o tamanho do ícone conforme necessário
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin:
                    EdgeInsets.all(20.0), // Ajuste a margem conforme necessário
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CustomerRegistrationScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Ajuste o valor para arredondar o botão
                    ),
                  ),
                  child: Text(
                    'Cadastrar Novo Cliente',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchWhatsapp(String text) async {
    // Remova todos os caracteres não numéricos do texto
    final phoneNumber = text.replaceAll(RegExp(r'[^0-9]'), '');
    // Verifique se o número não está vazio
    if (phoneNumber.isNotEmpty) {
      final whatsappUrl = Uri.parse('https://wa.me/55$phoneNumber');
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Número de telefone inválido.'),
      ));
    }
  }
}

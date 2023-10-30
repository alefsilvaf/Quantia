import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            suppliers.isEmpty
                ? Center(
                    child: Text('Ainda não há fornecedores cadastrados.'),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = suppliers[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              supplier['name'].toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text('Telefone: ${supplier['phone_number']}'),
                                SizedBox(height: 8.0),
                                Text('E-mail: ${supplier['email']}'),
                                SizedBox(height: 8.0),
                                Text('Endereço: ${supplier['address']}'),
                                SizedBox(height: 8.0),
                              ],
                            ),
                            onLongPress: () {
                              // Copie os detalhes do fornecedor para a área de transferência
                              final supplierDetails =
                                  'Nome: ${supplier['name']}\nTelefone: ${supplier['phone_number']}\nE-mail: ${supplier['email']}\nEndereço: ${supplier['address']}';

                              Clipboard.setData(
                                  ClipboardData(text: supplierDetails));

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Detalhes copiados'),
                              ));
                            },
                            trailing: GestureDetector(
                              onTap: () async {
                                _launchWhatsapp('${supplier['phone_number']}');
                              },
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                height: 60.0,
                                width: 48.0,
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                  size: 35.0,
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
                margin: EdgeInsets.all(35.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SupplierRegistrationScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Cadastrar Novo Fornecedor',
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

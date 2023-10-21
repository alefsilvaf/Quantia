import 'package:flutter/material.dart';
import '../database/supplier_database.dart';

class SupplierRegistrationScreen extends StatefulWidget {
  @override
  _SupplierRegistrationScreenState createState() =>
      _SupplierRegistrationScreenState();
}

class _SupplierRegistrationScreenState
    extends State<SupplierRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  void _registerSupplier() async {
    if (_formKey.currentState!.validate()) {
      final newSupplier = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'address': _addressController.text,
      };

      final supplierId =
          await SupplierDatabase.instance.insertSupplier(newSupplier);

      if (supplierId != null) {
        _loadSuppliers();
        _nameController.clear();
        _emailController.clear();
        _phoneNumberController.clear();
        _addressController.clear();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro no Registro'),
            content: Text('Ocorreu um erro ao registrar o fornecedor.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Fornecedor'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome:'),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('E-mail:'),
              TextFormField(
                controller: _emailController,
              ),
              SizedBox(height: 16.0),
              Text('Telefone:'),
              TextFormField(
                controller: _phoneNumberController,
              ),
              SizedBox(height: 16.0),
              Text('Endereço:'),
              TextFormField(
                controller: _addressController,
              ),
              SizedBox(height: 35.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _registerSupplier,
                  child: Text(
                    'Cadastrar Fornecedor',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Lista de Fornecedores',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: suppliers.isEmpty
                    ? Center(
                        child: Text('Nenhum fornecedor cadastrado.'),
                      )
                    : ListView.builder(
                        itemCount: suppliers.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(suppliers[index]['name']),
                              subtitle: Text(suppliers[index]['email'] ?? ''),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

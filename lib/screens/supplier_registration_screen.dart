import 'package:flutter/material.dart';
import '../database/supplier_database.dart';
import '../utils/success_message.dart';
import 'supplier_list_screen.dart'; // Importe a tela SupplierListScreen

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SuccessScreen(),
          ),
        );

        // Aguardar por um período (por exemplo, 2 segundos).
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                SupplierListScreen(), // Vá para a tela de listagem de fornecedores
          ),
        );
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Nome:'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome é obrigatório.';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('E-mail:'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Telefone:'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _phoneNumberController,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Endereço:'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _addressController,
                  style: TextStyle(fontSize: 18.0),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../database/customer_database.dart';
import 'customer_list_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  _CustomerRegistrationScreenState createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _registerCustomer() async {
    _emailController.text = _emailController.text.trim();
    if (_formKey.currentState!.validate()) {
      final customer = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'address': _addressController.text,
      };

      final customerId =
          await CustomerDatabase.instance.insertCustomer(customer);

      if (customerId != null) {
        // Registro bem-sucedido, navegue para a tela de lista de clientes.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CustomerListScreen(),
          ),
        );
      } else {
        // Lidar com o erro de registro, como exibir uma mensagem de erro.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro no Registro'),
            content: Text('Ocorreu um erro ao registrar o cliente.'),
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
        title: Text('Cadastro de Cliente'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 55.0,
          left: 35.0,
          right: 35.0,
          bottom: 35.0,
        ),
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
                    return 'Por favor, preencha o nome.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('E-mail:'),
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
              ),
              SizedBox(height: 16.0),
              Text('Telefone:'),
              TextFormField(
                controller: _phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o telefone.';
                  }
                  return null;
                },
                inputFormatters: [phoneNumberMaskFormatter],
              ),
              SizedBox(height: 16.0),
              Text('Endereço:'),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o endereço.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 35.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _registerCustomer,
                  child: Text(
                    'Cadastrar Cliente',
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha o e-mail.';
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  }

  // Máscara de telefone brasileira
  var phoneNumberMaskFormatter = MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
}

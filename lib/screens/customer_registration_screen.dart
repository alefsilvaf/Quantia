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
      resizeToAvoidBottomInset:
          false, // Isso evita que a tela seja redimensionada quando o teclado aparecer

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
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _registerCustomer,
                child: Text('Cadastrar Cliente'),
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

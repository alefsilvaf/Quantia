// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../database/user_database.dart';
import 'controle_geral_screen.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repetirSenhaController = TextEditingController();
  String? _senhaErrorText;
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Conta'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Crie sua conta',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _emailErrorText,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    errorText: _senhaErrorText,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _repetirSenhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Repita a Senha',
                    errorText: _senhaErrorText,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _registrarUsuario();
                  },
                  child: Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registrarUsuario() async {
    if (_senhaController.text != _repetirSenhaController.text) {
      setState(() {
        _senhaErrorText = 'As senhas não coincidem';
        _emailErrorText = null;
      });
    } else {
      setState(() {
        _senhaErrorText = null;
        _emailErrorText = null;
      });

      if (!_isEmailValid(_emailController.text)) {
        setState(() {
          _emailErrorText = 'Email inválido';
        });
      } else {
        final newUser = {
          'id': null,
          'username': _nomeController.text,
          'email': _emailController.text,
          'password': _senhaController.text,
        };

        final userId = await UserDatabase.instance.insertUser(newUser);

        if (userId != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ControleGeralScreen(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erro no Registro'),
              content: Text('Ocorreu um erro ao registrar o usuário.'),
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
  }

  bool _isEmailValid(String email) {
    final emailValido =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
    return emailValido;
  }
}

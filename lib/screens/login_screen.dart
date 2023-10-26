// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../database/user_database.dart';
import 'user_registration_screen.dart';
import 'general_control_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final UserDatabase userDatabase = UserDatabase.instance;

  Future<void> fazerLogin() async {
    final email = emailController.text;
    final senha = senhaController.text;

    final autenticado = await userDatabase.login(email, senha);

    if (autenticado) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ControleGeralScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Credenciais inválidas. Tente novamente.',
            style: TextStyle(
                color: Colors.white), // Defina a cor do texto como branco
          ),
          backgroundColor: Colors.red, // Defina a cor de fundo como vermelho
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Faça login',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    key: Key('emailField'),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    key: Key('senhaField'),
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: fazerLogin,
                  child: Text('Login'),
                ),
                SizedBox(height: 64),
                Text(
                  'Não possui uma conta? Cadastre-se agora!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CadastroScreen()),
                    );
                  },
                  child: Text('Cadastrar-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

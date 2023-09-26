// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0), // Espaçamento interno
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Faça login',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                  height: 16), // Espaço entre o texto e os campos de entrada
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32.0), // Espaçamento horizontal dos campos
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(height: 16), // Espaço entre os campos de entrada
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32.0), // Espaçamento horizontal dos campos
                child: TextField(
                  obscureText: true, // Para ocultar a senha
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
              ),
              SizedBox(
                  height: 32), // Espaço entre os campos de entrada e o botão
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica de autenticação aqui
                },
                child: Text('Login'),
              ),
              SizedBox(height: 64), // Espaço abaixo do botão

              Text(
                'Não possue uma conta? Cadastre-se agora!',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de cadastro quando o botão for pressionado.
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
    );
  }
}

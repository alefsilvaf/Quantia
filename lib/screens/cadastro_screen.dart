// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors
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
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 42.0), // Espaçamento interno
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Crie sua conta',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                  height: 16), // Espaço entre o texto e os campos de entrada
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              SizedBox(height: 16), // Espaço entre os campos de entrada
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailErrorText,
                ),
              ),
              SizedBox(height: 16), // Espaço entre os campos de entrada
              TextField(
                controller: _senhaController,
                obscureText: true, // Para ocultar a senha
                decoration: InputDecoration(
                  labelText: 'Senha',
                  errorText: _senhaErrorText,
                ),
              ),
              SizedBox(height: 16), // Espaço entre os campos de entrada
              TextField(
                controller: _repetirSenhaController,
                obscureText: true, // Para ocultar a senha
                decoration: InputDecoration(
                  labelText: 'Repita a Senha',
                  errorText: _senhaErrorText,
                ),
              ),
              SizedBox(
                  height: 16), // Espaço entre os campos de entrada e o botão
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
    );
  }

  void _registrarUsuario() async {
    // Realiza a validação da senha
    if (_senhaController.text != _repetirSenhaController.text) {
      setState(() {
        _senhaErrorText = 'As senhas não coincidem';
        _emailErrorText = null; // Limpa o erro de email
      });
    } else {
      setState(() {
        _senhaErrorText = null;
        _emailErrorText = null;
      });

      // Verifica se o email é válido
      if (!_isEmailValid(_emailController.text)) {
        setState(() {
          _emailErrorText = 'Email inválido';
        });
      } else {
        // Crie um mapa com os dados do usuário a serem inseridos no banco de dados
        final newUser = {
          'id': null,
          'username': _nomeController.text,
          'email': _emailController.text,
          'password': _senhaController.text,
        };

        // Insira o usuário no banco de dados
        final userId = await UserDatabase.instance.insertUser(newUser);

        if (userId != null) {
          // Registro bem-sucedido, navegue para a tela de Controle Geral
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ControleGeralScreen(),
            ),
          );
        } else {
          // Lidar com o erro de registro
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

import 'package:flutter/material.dart';
import '../database/user_database.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  List<Map<String, dynamic>> _users = []; // Lista para armazenar os usuários

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Carregue os usuários ao iniciar a tela
  }

  Future<void> _loadUsers() async {
    final users =
        await UserDatabase.instance.getUsers(); // Obtém todos os usuários
    setState(() {
      _users = users; // Atualiza a lista de usuários no estado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuários'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text('ID: ${user['id']}'),
            subtitle: Text('Nome: ${user['username']}'),
            // Você pode adicionar mais informações do usuário aqui
          );
        },
      ),
    );
  }
}

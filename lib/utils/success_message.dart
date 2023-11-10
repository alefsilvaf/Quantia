import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sucesso'),
      ),
      body: Container(
        color: Color(0xFF6D6AFC), // Cor de fundo da tela inteira
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle, // Ícone de verificação
                size: 96, // Tamanho do ícone
                color: Colors.white, // Cor do ícone
              ),
              SizedBox(height: 16.0), // Espaço entre o ícone e o texto
              Text(
                'Sucesso!',
                style: TextStyle(
                  fontSize: 24.0, // Tamanho de texto maior
                  fontWeight: FontWeight.bold, // Texto em negrito (mais grosso)
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

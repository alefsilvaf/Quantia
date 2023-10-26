// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../database/product_category_database.dart';

class ProductCategoryScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<ProductCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _refreshCategoryList();
  }

  _refreshCategoryList() async {
    var categories =
        await ProductCategoryDatabase.instance.getProductCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categorias de Produtos')),
      body: Padding(
        padding:
            const EdgeInsets.all(40.0), // Adiciona margens em todos os lados.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Cadastro:', // Título de cadastro
              style: TextStyle(
                fontSize:
                    20, // Estilize o tamanho da fonte e a aparência do título conforme necessário.
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome da Categoria'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O campo nome da categoria não pode estar vazio.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        InputDecoration(labelText: 'Descrição da Categoria'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O campo descrição da categoria não pode estar vazio.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      height:
                          30.0), // Adicione espaçamento vertical de 16.0 (ajuste conforme necessário).
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final existingCategory = await ProductCategoryDatabase
                            .instance
                            .getProductCategoryByName(_nameController.text);

                        if (existingCategory != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Aviso'),
                                content: Text(
                                    'Uma categoria com o mesmo nome já existe, crie uma nova ou use a já existente.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Map<String, dynamic> category = {
                            'name': _nameController.text,
                            'description': _descriptionController.text,
                          };
                          await ProductCategoryDatabase.instance
                              .insertProductCategory(category);
                          _refreshCategoryList();

                          // Limpar os campos após a inserção.
                          _nameController.clear();
                          _descriptionController.clear();

                          // Mostrar uma mensagem de sucesso.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Categoria registrada com sucesso.'),
                              backgroundColor:
                                  Colors.green, // Define a cor como verde.
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Registrar'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0), // Afastamento do topo do conteúdo abaixo.
            _categories.isEmpty
                ? Text('Nenhuma categoria cadastrada.')
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          alignment: Alignment
                              .centerLeft, // Alinhe o conteúdo à esquerda.

                          child: Text(
                            'Categorias Existentes:',
                            style: TextStyle(
                              fontSize:
                                  20, // Estilize o tamanho da fonte e a aparência do título conforme necessário.
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: ListTile(
                                  title: Text(
                                      _categories[index]['name'].toUpperCase()),
                                  subtitle: Text(
                                      _categories[index]['description'] ?? ''),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Classe para decodificar os dados JSON
class DadosJSON {
  final String title;

  DadosJSON({required this.title});

  factory DadosJSON.fromJson(Map<String, dynamic> json) {
    return DadosJSON(
      title: json['title'],
    );
  }
}

class Nova extends StatefulWidget {
  const Nova({Key? key}) : super(key: key);

  @override
  State<Nova> createState() => _NovaState();
}

class _NovaState extends State<Nova> {
  late Future<DadosJSON> meusDados;

  @override
  void initState() {
    super.initState();
    meusDados = _buscaDadosRemotos();
  }

  Future<DadosJSON> _buscaDadosRemotos() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

      if (response.statusCode == 200) {
        print('response statusCode is 200');
        final decodificada = json.decode(response.body);
        return DadosJSON.fromJson(decodificada);
      } else {
        print('Http Error: ${response.statusCode}!');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Filme'),
        ),
        body: Center(
          child: FutureBuilder<DadosJSON>(
            future: meusDados,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar dados: ${snapshot.error}');
              } else {
                return Text(snapshot.data!.title); // Exibir o título recebido
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Nova());
}

import 'package:cepapp/controller/consulta_cep_controller.dart';
import 'package:cepapp/views/consulta_cep_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ConsultaCepController(),
    ),
  ], child: const CepApp()));
}

class CepApp extends StatelessWidget {
  const CepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.lightBlue,
        ),
      ),
      home: const ConsultaCep(),
    );
  }
}

import 'dart:convert';
import 'package:cepapp/model/viacep_model.dart';
import 'package:cepapp/repository/viacep_repository.dart';
import 'package:http/http.dart' as http;

class ViaCepService implements ViaCepRepository {
  final url = 'https://viacep.com.br/ws/';
  @override
  Future<ViaCepModel> getAddress(String cep) async {
    var response = await http.get(Uri.parse('$url$cep/json/'));
    if (response.statusCode == 200) {
      var body = response.body;
      var json = jsonDecode(body);
      return ViaCepModel.fromJson(json);
    }
    throw Exception();
  }
}

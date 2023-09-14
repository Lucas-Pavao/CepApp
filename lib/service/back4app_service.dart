import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cepapp/model/viacep_model.dart';
import 'package:cepapp/repository/back4app_repository.dart';

class Back4AppService extends Back4AppRepository {
  String url = 'https://parseapi.back4app.com/parse/classes/cep';
  var headers = {
    "X-Parse-Application-Id": "k4DGJcyfQvSRNMhUyLJvWQFJfQj394zNFwTxU2Rj",
    "X-Parse-REST-API-Key": "k0wX0uG2PuznipiTY40dMbQZqz37jsbyu6Cgtfz4",
    "Content-Type": "application/json",
  };

  @override
  Future<List<ViaCepModel>> getCep() async {
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var body = response.body;
        var json = jsonDecode(body);
        return (json['results'] as List)
            .map((e) => ViaCepModel.fromJson(e))
            .toList();
      } else {
        // Lida com um erro HTTP não esperado (por exemplo, 404, 500)
        throw Exception('Erro na solicitação HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Lida com exceções gerais, como erro de conexão
      throw Exception('Erro ao obter CEPs: $e');
    }
  }

  @override
  Future<void> saveCep(ViaCepModel cep) async {
    try {
      await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(cep.toJson()),
      );
    } catch (e) {
      throw Exception('Erro ao salvar CEP: $e');
    }
  }

  @override
  Future<void> deleteCep(ViaCepModel cep) async {
    try {
      await http.delete(
        Uri.parse('$url/${cep.objectId}'),
        headers: headers,
      );
    } catch (e) {
      throw Exception('Erro ao deletar CEP: $e');
    }
  }

  @override
  Future<void> updateCep(ViaCepModel cep) async {
    try {
      await http.put(
        Uri.parse('$url/${cep.objectId}'),
        headers: headers,
        body: jsonEncode(cep.toJson()),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar CEP: $e');
    }
  }

  // @override
  // Future<bool> isCepSaved(ViaCepModel cep) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$url?where={"cep":"${cep.cep}"}'),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       // O CEP foi encontrado no servidor, então retornamos true
  //       return true;
  //     } else if (response.statusCode == 404) {
  //       // O CEP não foi encontrado no servidor, então retornamos false
  //       return false;
  //     } else {
  //       // Outro código de status, algo deu errado, lançamos uma exceção
  //       throw Exception(
  //           'Erro ao verificar se o CEP está salvo. Status Code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erro ao verificar se o CEP está salvo: $e');
  //   }
  // }
}

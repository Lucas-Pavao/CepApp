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
    }

    throw Exception();
  }

  @override
  Future<void> saveCep(ViaCepModel cep) {
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(cep.toJson()),
    );
  }
}

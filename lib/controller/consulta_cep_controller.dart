import 'package:cepapp/model/viacep_model.dart';
import 'package:cepapp/repository/back4app_repository.dart';
import 'package:cepapp/repository/viacep_repository.dart';
import 'package:cepapp/service/back4app_service.dart';
import 'package:cepapp/service/viacep_service.dart';
import 'package:flutter/material.dart';

class ConsultaCepController extends ChangeNotifier {
  TextEditingController cepController = TextEditingController();
  ViaCepRepository viaCepRepository = ViaCepService();
  Back4AppRepository back4AppRepository = Back4AppService();
  List<ViaCepModel> ceps = [];

  consultaCep(String cep) async {
    ViaCepModel viaCepModel = await viaCepRepository.getAddress(cep);
    await back4AppRepository.saveCep(viaCepModel);
    ceps.add(viaCepModel);
    carregaCeps();
  }

  carregaCeps() async {
    ceps = await back4AppRepository.getCep();
    notifyListeners();
  }
}

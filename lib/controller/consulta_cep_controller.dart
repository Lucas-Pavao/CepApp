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
  String _snackbarMessage = '';

  String get snackbarMessage => _snackbarMessage;
  void setSnacbarmessage(String value) {
    _snackbarMessage = value;
    notifyListeners();
  }

  consultaCep(String cep) async {
    ViaCepModel viaCepModel = await viaCepRepository.getAddress(cep);
    var cepSalvo = false;
    for (var element in ceps) {
      if (element.cep == viaCepModel.cep) {
        cepSalvo = true;
        break;
      }
    }
    if (cepSalvo == false) {
      await back4AppRepository.saveCep(viaCepModel);
      ceps.add(viaCepModel);
      carregaCeps();
      _snackbarMessage = "CEP cadastrado com sucesso!";
    } else {
      _snackbarMessage = "CEP já cadastrado!";
    }
    notifyListeners();

    // Redefina a variável snackbarMessage após um curto período
    Future.delayed(const Duration(seconds: 2), () {
      _snackbarMessage = '';
      notifyListeners();
    });
  }

  deleteCep(ViaCepModel cep) async {
    await back4AppRepository.deleteCep(cep);

    ceps.removeWhere((element) => element.objectId == cep.objectId);
    notifyListeners();
  }

  updateCep(ViaCepModel cep) async {
    await back4AppRepository.updateCep(cep);
    notifyListeners();
  }

  carregaCeps() async {
    ceps = await back4AppRepository.getCep();
    notifyListeners();
  }
}

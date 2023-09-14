import 'package:cepapp/model/viacep_model.dart';

abstract class ViaCepRepository {
  Future<ViaCepModel> getAddress(String cep);
}

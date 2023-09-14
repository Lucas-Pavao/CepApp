import 'package:cepapp/model/viacep_model.dart';

abstract class Back4AppRepository {
  Future<List<ViaCepModel>> getCep();
  Future<void> saveCep(ViaCepModel cep);
}

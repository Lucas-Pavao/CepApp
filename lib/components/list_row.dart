import 'package:cepapp/model/viacep_model.dart';
import 'package:flutter/material.dart';

class ListRow extends StatelessWidget {
  ListRow({super.key, required this.cep, required this.isSelected});
  bool isSelected = false;
  ViaCepModel cep;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(3, 168, 244, 0.544)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'CEP: ${cep.cep}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Logradouro: ${cep.logradouro}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              'UF: ${cep.uf}, Cidade: ${cep.localidade}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ]),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit,
                color: isSelected ? Colors.white : Colors.indigo),
          ),
        ],
      ),
    );
  }
}

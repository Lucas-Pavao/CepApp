import 'package:cepapp/components/list_row.dart';
import 'package:cepapp/controller/consulta_cep_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaCep extends StatefulWidget {
  const ConsultaCep({super.key});

  @override
  State<ConsultaCep> createState() => _ConsultaCepState();
}

class _ConsultaCepState extends State<ConsultaCep> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final ConsultaCepController consultaCepController =
        Provider.of<ConsultaCepController>(context);
    setState(() {
      consultaCepController.carregaCeps();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta CEP'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'CEP',
                        hintText: 'Digite o CEP',
                        icon: Icon(Icons.location_on)),
                    controller: consultaCepController.cepController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    consultaCepController
                        .consultaCep(consultaCepController.cepController.text);
                  },
                  child: const Text('Consultar'),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "CEPs Cadastrados",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: consultaCepController.ceps.isEmpty
                  ? const Center(child: Text("Nenhum Cep Cadastrado!"))
                  : ListView.builder(
                      itemCount: consultaCepController.ceps.length,
                      itemBuilder: (context, index) {
                        bool isSelected = _selectedIndex == index;
                        if (index < consultaCepController.ceps.length) {
                          return GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
                                      content: const Text('Excluir Cep?'),
                                      action: SnackBarAction(
                                        label: 'Excluir',
                                        onPressed: () {
                                          // Remova o item da lista quando a ação for pressionada
                                          setState(() {
                                            _selectedIndex =
                                                -1; // Ressalta a cor para o branco
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                  .closed
                                  .then((reason) {
                                if (reason != SnackBarClosedReason.action) {
                                  // A Snackbar foi fechada sem acionar a ação
                                  setState(() {
                                    _selectedIndex =
                                        -1; // Ressalta a cor para o branco
                                  });
                                }
                              });
                            },
                            child: ListRow(
                              cep: consultaCepController.ceps[index],
                              isSelected: isSelected,
                            ),
                          );
                        } else {
                          // Tratar o caso em que o índice está fora dos limites da lista.
                          return const SizedBox
                              .shrink(); // Ou qualquer outro widget vazio.
                        }
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

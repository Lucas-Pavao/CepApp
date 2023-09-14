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

  bool cepsCarregados = false;

  @override
  Widget build(BuildContext context) {
    final ConsultaCepController consultaCepController =
        Provider.of<ConsultaCepController>(context);

    if (consultaCepController.snackbarMessage.isNotEmpty) {
      // Se a mensagem não estiver vazia, agende a exibição da Snackbar após o build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(consultaCepController.snackbarMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }

    // Verifique se os CEPs ainda não foram carregados
    if (!cepsCarregados) {
      consultaCepController.carregaCeps();
      cepsCarregados = true; // Marque como carregado para evitar recarregar
    }

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        consultaCepController.setSnacbarmessage(
                            "Por favor, digite um CEP válido!");
                      }

                      // Remova espaços e hífens do valor do CEP
                      final cleanedValue =
                          value?.replaceAll(RegExp(r'[ -]'), '');

                      // Verifique se o CEP tem exatamente 8 dígitos
                      if (cleanedValue?.length != 8 ||
                          !RegExp(r'^[0-9]+$').hasMatch(cleanedValue!)) {
                        consultaCepController.setSnacbarmessage(
                            "Por favor, digite um CEP válido!");
                      }

                      return null;
                    },
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
                                          consultaCepController.deleteCep(
                                              consultaCepController
                                                  .ceps[index]);
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
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    final keyboardHeight =
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom;

                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: keyboardHeight,
                                          top: 10,
                                          left: 10,
                                          right:
                                              10, // Defina a margem inferior para a altura do teclado
                                        ),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Editar CEP',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                controller:
                                                    TextEditingController(
                                                  text: consultaCepController
                                                      .ceps[index].logradouro,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Logradouro',
                                                ),
                                                onChanged: (value) {
                                                  consultaCepController
                                                      .ceps[index]
                                                      .logradouro = value;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                controller:
                                                    TextEditingController(
                                                  text: consultaCepController
                                                      .ceps[index].bairro,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Bairro',
                                                ),
                                                onChanged: (value) {
                                                  consultaCepController
                                                      .ceps[index]
                                                      .bairro = value;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                controller:
                                                    TextEditingController(
                                                  text: consultaCepController
                                                      .ceps[index].localidade,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Cidade',
                                                ),
                                                onChanged: (value) {
                                                  consultaCepController
                                                      .ceps[index]
                                                      .localidade = value;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  consultaCepController
                                                      .updateCep(
                                                    consultaCepController
                                                        .ceps[index],
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Salvar'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          // Tratar o caso em que o índice está fora dos limites da lista.
                          return const SizedBox
                              .shrink(); // Ou qualquer outro widget vazio.
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

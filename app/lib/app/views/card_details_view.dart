import 'package:app/app/controllers/account_controller.dart';
import 'package:app/app/models/account_model.dart';
import 'package:app/app/models/card_model.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/card_controller.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({super.key});

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  late CardModel card;
  late CardModel oldCard;
  late List<BankModel> banks = [];
  late List<BrandModel> brands = [];
  late BankModel? selectedBank = null;
  late BrandModel? selectedBrand = null;
  final String defaultImageUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Flag_Blank.svg/2560px-Flag_Blank.svg.png";
  final cardController = CardController();
  final accountController = AccountController();
  final TextEditingController _textStartDayController = TextEditingController();
  final TextEditingController _textDueDayController = TextEditingController();
  final MoneyMaskedTextController _moneyMaskedController =
      MoneyMaskedTextController(
          decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  @override
  void initState() {
    super.initState();

    loadBanks().then((itens) {
      setState(() {
        banks = itens;
        selectedBank = card.bank;
      });
    });

    loadBrands().then((itens) {
      setState(() {
        brands = itens;
        selectedBrand = card.brand;
      });
    });
  }

  Future<List<BankModel>> loadBanks() async {
    return await accountController.getBanks();
  }

  Future<List<BrandModel>> loadBrands() async {
    return await cardController.getBrands();
  }

  @override
  void dispose() {
    _moneyMaskedController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as CardModel?;

    if (data == null) {
      card = CardModel();
    } else {
      selectedBank = data.bank;
      selectedBrand = data.brand;
      card = data;
      oldCard = card.clone();
    }

    _moneyMaskedController.text = card.creditLimit != null
        ? NumberFormat.simpleCurrency(locale: "pt-BR").format(card.creditLimit)
        : "";
    _textStartDayController.text =
        card.billingStartDay != null ? card.billingStartDay.toString() : "1";
    _textDueDayController.text =
        card.billingDueDay != null ? card.billingDueDay.toString() : "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: card.id == null
            ? const Text("Cadastrar Cartão")
            : const Text("Editar Cartão"),
        backgroundColor: Color.fromARGB(255, 210, 98, 98),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  ImageIconWidget(card: card, defaultImageUrl: defaultImageUrl),
                  NameInputWidget(card: card),
                  LimitInputWidget(
                      card: card,
                      moneyMaskedController: _moneyMaskedController),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<BankModel>(
                      value: selectedBank,
                      items: banks.isEmpty && card.id != null
                          ? [
                              DropdownMenuItem<BankModel>(
                                value: card.bank,
                                child: Text(card.bank?.name ?? ""),
                              )
                            ]
                          : banks
                              .map(
                                (e) => DropdownMenuItem<BankModel>(
                                  value: e,
                                  child: Text(e.name ?? ""),
                                ),
                              )
                              .toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Instituição'),
                      onChanged: (bank) {
                        setState(
                          () {
                            card.bank = bank!;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<BrandModel>(
                      value: selectedBrand,
                      items: brands.isEmpty && card.id != null
                          ? [
                              DropdownMenuItem<BrandModel>(
                                value: card.brand,
                                child: Text(card.brand!.name ?? ""),
                              )
                            ]
                          : brands
                              .map(
                                (e) => DropdownMenuItem<BrandModel>(
                                    value: e, child: Text(e.name ?? "")),
                              )
                              .toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Bandeira'),
                      onChanged: (accounType) {
                        setState(
                          () {
                            card.brand = accounType!;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _textStartDayController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        card.billingStartDay = int.tryParse(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Data de início da fatura",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _textDueDayController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        card.billingDueDay = int.tryParse(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Data de vencimento da fatura",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: card.id != null
          ? UpdateFloatingActionWidget(
              card: card, cardController: cardController)
          : CreateFloatingActionWidget(
              card: card, cardController: cardController),
    );
  }
}

class LimitInputWidget extends StatelessWidget {
  const LimitInputWidget({
    super.key,
    required this.card,
    required MoneyMaskedTextController moneyMaskedController,
  }) : _moneyMaskedController = moneyMaskedController;

  final CardModel card;
  final MoneyMaskedTextController _moneyMaskedController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          onChanged: (text) {
            card.creditLimit = _moneyMaskedController.numberValue;
          },
          controller: _moneyMaskedController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Limite',
          )),
    );
  }
}

class NameInputWidget extends StatelessWidget {
  const NameInputWidget({
    super.key,
    required this.card,
  });

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: card.name ?? "",
        onChanged: (text) {
          card.name = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nome',
        ),
      ),
    );
  }
}

class ImageIconWidget extends StatelessWidget {
  const ImageIconWidget({
    super.key,
    required this.card,
    required this.defaultImageUrl,
  });

  final CardModel card;
  final String defaultImageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            card.brand?.imageUrl ?? defaultImageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class UpdateFloatingActionWidget extends StatelessWidget {
  const UpdateFloatingActionWidget({
    super.key,
    required this.card,
    required this.cardController,
  });

  final CardModel card;
  final CardController cardController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FloatingActionButton(
            heroTag: "delete",
            backgroundColor: Colors.red,
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Tem certeza disso?'),
                  content: const Text(
                      'Todas as transações associadas a este cartão serão apagados.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancelar');
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Excluir');
                        cardController.deleteCard(card);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.delete),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FloatingActionButton(
            heroTag: "save",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.save),
            onPressed: () {
              if (card.id != null) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmar alteração?'),
                    content: const Text(
                        'Atualizar o limite impactará no valor de limite disponível.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancelar');
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Confirmar');
                          cardController.updateCard(card);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                );
              } else {
                cardController.createCard(card);
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }
}

class CreateFloatingActionWidget extends StatelessWidget {
  const CreateFloatingActionWidget({
    super.key,
    required this.card,
    required this.cardController,
  });

  final CardModel card;
  final CardController cardController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              cardController.createCard(card);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}

import 'package:app/app/controllers/account_controller.dart';
import 'package:app/app/controllers/card_controller.dart';
import 'package:app/app/controllers/exchange_controller.dart';
import 'package:app/app/models/account_model.dart';
import 'package:app/app/models/card_model.dart';
import 'package:app/app/models/exchange_model.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ExchangeDetailsPage extends StatefulWidget {
  const ExchangeDetailsPage({super.key});

  @override
  State<ExchangeDetailsPage> createState() => _ExchangeDetailsPageState();
}

class _ExchangeDetailsPageState extends State<ExchangeDetailsPage> {
  late ExchangeModel exchange;
  late ExchangeModel oldExchange;
  late List<AccountModel> accounts = [];
  late List<CardModel> cards = [];
  late PaymentMethodModel paymentMethod = PaymentMethodModel();
  late MovementTypeModel movementTypeModel = MovementTypeModel();
  late AccountModel? selectedAccount = null;
  late CardModel? selectedCard = null;
  late String? selectedPaymentMethodModel = null;
  late int movementTypeInitialValue = 0;
  final String defaultImageUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Flag_Blank.svg/2560px-Flag_Blank.svg.png";
  final exchangeController = ExchangeController();
  final accountController = AccountController();
  final cardController = CardController();
  final TextEditingController _textStartDayController = TextEditingController();
  final TextEditingController _textDueDayController = TextEditingController();
  final MoneyMaskedTextController _moneyMaskedController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final TextEditingController _dateInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadAccounts().then((items) {
      setState(() {
        accounts = items;
        selectedAccount = exchange.account;
      });
    });

    loadCards().then((items) {
      setState(() {
        cards = items;
        selectedCard = exchange.billing != null ? exchange.billing!.card : null;
      });
    });
  }

  Future<List<AccountModel>> loadAccounts() async {
    return await accountController.getAccounts();
  }

  Future<List<CardModel>> loadCards() async {
    return await cardController.getCards();
  }

  @override
  void dispose() {
    _moneyMaskedController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as ExchangeModel?;

    if (data == null) {
      exchange = ExchangeModel();
      exchange.movementType = -1;
    } else {
      selectedAccount = data.account;
      selectedCard = data.billing != null ? data.billing!.card : null;
      selectedPaymentMethodModel =
          data.billing != null ? paymentMethod.CREDIT_CARD["key"] : paymentMethod.DEBIT_CARD["key"];
      movementTypeInitialValue = data.movementType! > 0 ? 1 : 0;
      exchange = data;
      oldExchange = exchange.clone();
      _dateInputController.text = DateFormat("dd/MM/yyyy").format(exchange.date!);
    }

    _moneyMaskedController.text =
        exchange.value != null ? NumberFormat.simpleCurrency(locale: "pt-BR").format(exchange.value) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: exchange.id == null ? const Text("Cadastrar Transação") : const Text("Editar Transação"),
        backgroundColor: Theme.of(context).primaryColor,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: exchange.description ?? "",
                      onChanged: (text) {
                        exchange.description = text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedPaymentMethodModel,
                      items: [
                        DropdownMenuItem<String>(
                          value: paymentMethod.CREDIT_CARD["key"],
                          child: Text(paymentMethod.CREDIT_CARD["value"]),
                        ),
                        DropdownMenuItem<String>(
                          value: paymentMethod.DEBIT_CARD["key"],
                          child: Text(paymentMethod.DEBIT_CARD["value"]),
                        ),
                      ],
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Método de Pagamento'),
                      onChanged: (value) {
                        setState(
                          () {
                            exchange.paymentType = value;
                            selectedPaymentMethodModel = value;
                          },
                        );
                      },
                    ),
                  ),
                  selectedPaymentMethodModel == paymentMethod.CREDIT_CARD["key"]
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<CardModel>(
                            value: selectedCard,
                            items: cards.isEmpty && exchange.id != null
                                ? [
                                    DropdownMenuItem<CardModel>(
                                      value: exchange.billing!.card,
                                      child: Text(exchange.billing!.card!.name ?? ""),
                                    )
                                  ]
                                : cards
                                    .map(
                                      (e) => DropdownMenuItem<CardModel>(value: e, child: Text(e.name ?? "")),
                                    )
                                    .toList(),
                            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Cartão'),
                            onChanged: (value) {
                              setState(
                                () {
                                  selectedCard = value!;
                                },
                              );
                            },
                          ),
                        )
                      : selectedPaymentMethodModel == paymentMethod.DEBIT_CARD["key"]
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<AccountModel>(
                                value: selectedAccount,
                                items: accounts.isEmpty && exchange.id != null
                                    ? [
                                        DropdownMenuItem<AccountModel>(
                                          value: exchange.account,
                                          child: Text(exchange.account!.name ?? ""),
                                        )
                                      ]
                                    : accounts
                                        .map(
                                          (e) => DropdownMenuItem<AccountModel>(value: e, child: Text(e.name ?? "")),
                                        )
                                        .toList(),
                                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Conta'),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      exchange.account = value!;
                                    },
                                  );
                                },
                              ),
                            )
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        onChanged: (text) {
                          exchange.value = _moneyMaskedController.numberValue;
                        },
                        controller: _moneyMaskedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Valor',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _dateInputController,
                      //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Data" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          setState(() {
                            _dateInputController.text = formattedDate; //set output date to TextField value.
                            exchange.date = pickedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleSwitch(
                      minWidth: 150.0,
                      initialLabelIndex: movementTypeInitialValue,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: const ['Despesa', 'Receita'],
                      icons: const [Icons.arrow_downward_rounded, Icons.arrow_upward_rounded],
                      activeBgColors: const [
                        [Colors.red],
                        [Colors.green],
                      ],
                      onToggle: (index) {
                        exchange.movementType = index == 0 ? movementTypeModel.EXPENSE : movementTypeModel.INCOME;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: exchange.id != null
          ? UpdateFloatingActionWidget(
              exchange: exchange,
              exchangeController: exchangeController,
              selectedCard: selectedCard,
            )
          : CreateFloatingActionWidget(
              exchange: exchange, exchangeController: exchangeController, selectedCard: selectedCard),
    );
  }
}

class UpdateFloatingActionWidget extends StatelessWidget {
  const UpdateFloatingActionWidget(
      {super.key, required this.exchange, required this.exchangeController, required this.selectedCard});

  final ExchangeModel exchange;
  final ExchangeController exchangeController;
  final CardModel? selectedCard;

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
              exchangeController.deleteExchange(exchange);
              Navigator.of(context).pop();
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
              if (exchange.id != null) {
                exchangeController.updateExchange(exchange);
              } else {
                exchangeController.createExchange(exchange, selectedCard!);
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
  const CreateFloatingActionWidget(
      {super.key, required this.exchange, required this.exchangeController, required this.selectedCard});

  final ExchangeModel exchange;
  final ExchangeController exchangeController;
  final CardModel? selectedCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              exchangeController.createExchange(exchange, selectedCard);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}

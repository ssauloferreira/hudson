import 'package:app/app/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:intl/intl.dart';

import '../controllers/account_controller.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late AccountModel account;
  late AccountModel oldAccount;
  late List<AccountTypeModel> accountTypes = [];
  late List<BankModel> banks = [];
  late BankModel? selectedBank = null;
  late AccountTypeModel? selectedAccountType = null;
  final String defaultImageUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Flag_Blank.svg/2560px-Flag_Blank.svg.png";

  final accountController = AccountController();
  final MoneyMaskedTextController _moneyMaskedController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  @override
  void initState() {
    super.initState();

    loadBanks().then((itens) {
      setState(() {
        banks = itens;
        selectedBank = account.bank;
      });
    });

    loadAccountTypes().then((itens) {
      setState(() {
        accountTypes = itens;
        selectedAccountType = account.type;
      });
    });
  }

  Future<List<BankModel>> loadBanks() async {
    return await accountController.getBanks();
  }

  Future<List<AccountTypeModel>> loadAccountTypes() async {
    return await accountController.getAccountTypes();
  }

  @override
  void dispose() {
    _moneyMaskedController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as AccountModel?;

    if (data == null) {
      account = AccountModel();
    } else {
      selectedBank = data.bank!;
      account = data;
      oldAccount = account.clone();
    }

    _moneyMaskedController.text =
        account.balance != null ? NumberFormat.simpleCurrency(locale: "pt-BR").format(account.balance) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: account.id == null ? const Text("Cadastrar Conta") : const Text("Editar Conta"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          account.bank?.imageUrl ?? defaultImageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: account.name ?? "",
                      onChanged: (text) {
                        account.name = text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da conta',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        onChanged: (text) {
                          account.balance = _moneyMaskedController.numberValue;
                        },
                        controller: _moneyMaskedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Total em conta',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<BankModel>(
                      value: selectedBank,
                      items: banks.isEmpty && account.id != null
                          ? [
                              DropdownMenuItem<BankModel>(
                                value: account.bank,
                                child: Text(account.bank!.name!),
                              )
                            ]
                          : banks
                              .map(
                                (e) => DropdownMenuItem<BankModel>(
                                  value: e,
                                  child: Text(e.name!),
                                ),
                              )
                              .toList(),
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Instituição'),
                      onChanged: (bank) {
                        setState(
                          () {
                            account.bank = bank!;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<AccountTypeModel>(
                      value: selectedAccountType,
                      items: accountTypes.isEmpty && account.id != null
                          ? [
                              DropdownMenuItem<AccountTypeModel>(
                                value: account.type,
                                child: Text(account.type!.name ?? ""),
                              )
                            ]
                          : accountTypes
                              .map(
                                (e) => DropdownMenuItem<AccountTypeModel>(value: e, child: Text(e.name ?? "")),
                              )
                              .toList(),
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Tipo de conta'),
                      onChanged: (accounType) {
                        setState(
                          () {
                            account.type = accounType!;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: account.id != null
          ? UpdateFloatingActionWidget(account: account, accountController: accountController)
          : CreateFloatingActionWidget(account: account, accountController: accountController),
    );
  }
}

class UpdateFloatingActionWidget extends StatelessWidget {
  const UpdateFloatingActionWidget({
    super.key,
    required this.account,
    required this.accountController,
  });

  final AccountModel account;
  final AccountController accountController;

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
                  content: const Text('Todas as transações associados a esta conta serão apagados.'),
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
                        accountController.deleteAccount(account);
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
              if (account.id != null) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmar alteração?'),
                    content: const Text(
                        'Caso o total da conta seja alterado, haverá um lançamento de transação para ajustar o valor.'),
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
                          accountController.updateAccount(account);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                );
              } else {
                accountController.createAccount(account);
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
    required this.account,
    required this.accountController,
  });

  final AccountModel account;
  final AccountController accountController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            if (account.id != null) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmar alteração?'),
                  content: const Text(
                      'Caso o total da conta seja alterado, haverá um lançamento de transação para ajustar o valor.'),
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
                        accountController.updateAccount(account);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              );
            } else {
              accountController.createAccount(account);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

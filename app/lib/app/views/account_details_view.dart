import 'package:app/app/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

import '../controllers/account_controller.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late AccountModel account;
  final accountController = AccountController();
  final MoneyMaskedTextController _moneyMaskedController =
      MoneyMaskedTextController(
          decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as AccountModel?;

    if (data == null)
      account = AccountModel();
    else
      account = data;

    _moneyMaskedController.text = account.total.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Conta"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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
                  child: DropdownButtonFormField<BankModel>(
                    items: accountController
                        .getBanks()
                        .map((e) => DropdownMenuItem<BankModel>(
                            value: e, child: Text(e.name ?? "")))
                        .toList(),
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
                  child: TextFormField(
                    onChanged: (text) {
                      account.total = text as double;
                    },
                    controller: _moneyMaskedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Total em conta'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<AccountTypeModel>(
                    items: accountController
                        .getAccountTypes()
                        .map((e) => DropdownMenuItem<AccountTypeModel>(
                            value: e, child: Text(e.name ?? "")))
                        .toList(),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          accountController.createAccount(account);
          Navigator.of(context).pushReplacementNamed('/account_list');
        },
      ),
    );
  }
}

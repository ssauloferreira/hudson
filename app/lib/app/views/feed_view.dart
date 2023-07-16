import 'dart:async';

import 'package:hudson/app/components/sidebar_widget.dart';
import 'package:hudson/app/controllers/account_controller.dart';
import 'package:hudson/app/controllers/card_controller.dart';
import 'package:hudson/app/controllers/exchange_controller.dart';
import 'package:hudson/app/models/account_model.dart';
import 'package:hudson/app/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:intl/intl.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  AccountController accountController = AccountController();
  List<AccountModel> accounts = [];
  CardController cardController = CardController();
  ExchangeController exchangeController = ExchangeController();
  List<CardModel> cards = [];
  double total = 0;
  double thisWeek = 0;
  double thisMonth = 0;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  FutureOr onBack(dynamic value) {
    refreshData();
  }

  refreshData() {
    loadAccounts().then((itens) {
      setState(() {
        accounts = itens;
        total = accounts.fold(0, (total, account) => total + account.balance!);
      });
    });

    loadCards().then((itens) {
      setState(() {
        cards = itens;
      });
    });

    loadRecentExchanges().then((itens) {
      setState(() {
        thisWeek = itens["thisWeek"];
        thisMonth = itens["thisMonth"];
      });
    });
  }

  Future<List<AccountModel>> loadAccounts() async {
    return await accountController.getAccounts();
  }

  Future<List<CardModel>> loadCards() async {
    return await cardController.getCards();
  }

  Future<Map<String, dynamic>> loadRecentExchanges() async {
    return await exchangeController.getRecentExchanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PatrimonyWidget(total: total),
          RecentExchangesWidget(thisWeek: thisWeek, thisMonth: thisMonth),
          AccountCardWidget(accounts: accounts, onBack: onBack),
          CardCardWidget(cards: cards, onBack: onBack),
        ],
      ),
    );
  }
}

class PatrimonyWidget extends StatelessWidget {
  final double total;

  const PatrimonyWidget({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text("Patrimônio"),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child:
                      Text(NumberFormat.simpleCurrency(locale: "pt-BR").format(total), style: TextStyle(fontSize: 35)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentExchangesWidget extends StatelessWidget {
  final double thisWeek;
  final double thisMonth;

  const RecentExchangesWidget({Key? key, required this.thisWeek, required this.thisMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Card(
            color: thisWeek == 0
                ? Colors.grey[50]
                : thisWeek < 0
                    ? Colors.red[50]
                    : Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  thisWeek == 0
                      ? Icon(Icons.horizontal_rule_rounded)
                      : thisWeek < 0
                          ? Icon(Icons.arrow_downward_rounded, color: Colors.red)
                          : Icon(Icons.arrow_upward_rounded, color: Colors.green),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Esta semana"),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(NumberFormat.simpleCurrency(locale: "pt-BR").format(thisWeek),
                            style: TextStyle(fontSize: 22)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: thisMonth == 0
                ? Colors.grey[50]
                : thisMonth < 0
                    ? Colors.red[50]
                    : Colors.green[50],
            child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    thisMonth == 0
                        ? Icon(Icons.horizontal_rule_rounded)
                        : thisMonth < 0
                            ? Icon(Icons.arrow_downward_rounded, color: Colors.red)
                            : Icon(Icons.arrow_upward_rounded, color: Colors.green),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Este mês"),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(NumberFormat.simpleCurrency(locale: "pt-BR").format(thisMonth),
                              style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}

class AccountCardWidget extends StatelessWidget {
  final List<AccountModel> accounts;
  final FutureOr<dynamic> Function(Object?) onBack;

  const AccountCardWidget({Key? key, required this.accounts, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/account_list').then(onBack);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "Minhas contas",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: accounts
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.name!,
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(locale: "pt-BR").format(e.balance!),
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardCardWidget extends StatelessWidget {
  final List<CardModel> cards;
  final FutureOr<dynamic> Function(Object?) onBack;

  const CardCardWidget({Key? key, required this.cards, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/card_list').then(onBack);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "Meus cartões",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: cards
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.name!,
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(locale: "pt-BR").format(e.availableLimit!),
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Card(
    //   child: InkWell(
    //     onTap: () {
    //       Navigator.of(context).pushNamed('/card_list');
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(12),
    //       child: SizedBox(
    //         width: MediaQuery.of(context).size.width,
    //         child: Text("Meus cartões"),
    //       ),
    //     ),
    //   ),
    // );
  }
}

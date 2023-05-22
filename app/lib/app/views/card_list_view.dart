import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../controllers/card_controller.dart';
import '../models/card_model.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({super.key});

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  final cardController = CardController();
  late List<CardModel> cards = [];

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  FutureOr onBack(dynamic value) {
    refreshData();
  }

  refreshData() {
    loadCards().then((itens) {
      setState(() {
        cards = itens;
      });
    });
  }

  Future<List<CardModel>> loadCards() async {
    return await cardController.getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cartões"),
      ),
      body: Column(
        children: CardCard(context).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/card_details').then(onBack);
        },
      ),
    );
  }

  Iterable<Card> CardCard(BuildContext context) {
    return cards.map(
      (e) => Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/card_details', arguments: e)
                .then(onBack);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              e.brand?.imageUrl ?? "",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                e.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                e.brand!.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w100),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Limite disponível",
                          style: TextStyle(fontWeight: FontWeight.w100),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          NumberFormat.simpleCurrency(locale: "pt-BR")
                              .format(e.availableLimit),
                          style: const TextStyle(fontWeight: FontWeight.w100),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

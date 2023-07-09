import 'dart:async';

import 'package:app/app/controllers/exchange_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../models/exchange_model.dart';

class ExchangeListPage extends StatefulWidget {
  const ExchangeListPage({super.key});

  @override
  State<ExchangeListPage> createState() => _ExchangeListPageState();
}

class _ExchangeListPageState extends State<ExchangeListPage> {
  final exchangeController = ExchangeController();
  late List<ExchangeModel> exchanges = [];

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  FutureOr onBack(dynamic value) {
    refreshData();
  }

  refreshData() {
    loadExchanges().then((itens) {
      setState(() {
        exchanges = itens;
      });
    });
  }

  Future<List<ExchangeModel>> loadExchanges() async {
    return await exchangeController.getExchanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: ExchangeCard(context).toList(),
      ),
    );
  }

  Iterable<Widget> ExchangeCard(BuildContext context) {
    return exchanges.map(
      (e) => Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/exchange_details', arguments: e)
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
                            child: e.movementType! > 0
                                ? const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: Colors.red,
                                  )),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                e.description.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                e.account != null
                                    ? e.account!.name ?? ""
                                    : e.billing!.card!.name ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w100),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(e.date!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Text(
                      NumberFormat.simpleCurrency(locale: "pt-BR")
                          .format(e.value),
                      style: const TextStyle(fontWeight: FontWeight.w100),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

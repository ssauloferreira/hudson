import 'dart:ffi';

import 'package:app/app/components/sidebar_widget.dart';
import 'package:app/app/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final accountController = AccountController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contas"),
      ),
      body: Column(
        children: AccountCard(context).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/account_details');
        },
      ),
    );
  }

  Iterable<Card> AccountCard(BuildContext context) {
    return accountController.accounts.map(
      (e) => Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/account_details', arguments: e);
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
                              e.bank?.imageUrl ?? "",
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
                              width: 100,
                              child: Text(
                                e.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                e.bank.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w100),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      NumberFormat.simpleCurrency(locale: "pt-BR")
                          .format(e.total),
                      style: const TextStyle(fontWeight: FontWeight.w100),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

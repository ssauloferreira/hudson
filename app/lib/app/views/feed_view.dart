import 'package:app/app/components/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AccountCardWidget(),
          CardCardWidget(),
        ],
      ),
    );
  }
}

class AccountCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/account_list');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text("Minhas contas"),
          ),
        ),
      ),
    );
  }
}

class CardCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/card_list');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text("Meus cartões"),
          ),
        ),
      ),
    );
  }
}

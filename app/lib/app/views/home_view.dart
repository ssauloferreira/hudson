import 'package:app/app/components/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarDrawer(),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          AccountCardWidget(),
          CardCardWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Novo Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Fatura',
          )
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
          Navigator.of(context).pushNamed('/card');
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

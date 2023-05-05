import 'package:app/sidebar_widget.dart';
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
        title: Text("HomePage"),
      ),
      body: Container(
        child: Text("Home Page"),
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

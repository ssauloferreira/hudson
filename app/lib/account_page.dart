import 'package:app/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarDrawer(),
      appBar: AppBar(
        title: Text("Contas"),
      ),
      body: Container(
        child: Text("Conta"),
      ),
    );
  }
}

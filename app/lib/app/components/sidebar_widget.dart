import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("curtisjones@lfc.uk", style: TextStyle(color: Colors.white)),
            accountName: Text("Curtis Jones", style: TextStyle(color: Colors.white)),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  Image.network("https://resources.premierleague.com/premierleague/photos/players/250x250/p206915.png"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pushNamed('/home')},
          ),
          ListTile(
            leading: Icon(Icons.wallet),
            title: Text('Conta'),
            subtitle: Text("Gerencie as suas contas"),
            onTap: () => {Navigator.of(context).pushNamed('/account_list')},
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Cartões'),
            subtitle: Text("Gerencie os seus cartões"),
            onTap: () => {Navigator.of(context).pushNamed('/card_list')},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            subtitle: Text("Sair do aplicativo"),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/')},
          ),
        ],
      ),
    );
  }
}

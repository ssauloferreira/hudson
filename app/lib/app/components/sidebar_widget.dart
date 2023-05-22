import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: SizedBox(
          //     height: double.infinity,
          //     width: double.infinity,
          //     child: Container(
          //       color: Colors.blue,
          //       child: Text(
          //         'Menu',
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          UserAccountsDrawerHeader(
            accountEmail: Text("curtisjones@lfc.uk"),
            accountName: Text("Curtis Jones"),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                  "https://resources.premierleague.com/premierleague/photos/players/250x250/p206915.png"),
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
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          // ListTile(
          //   leading: Icon(Icons.border_color),
          //   title: Text('Feedback'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
        ],
      ),
    );
  }
}

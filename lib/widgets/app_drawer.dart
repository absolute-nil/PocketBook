import 'package:flutter/material.dart';
import 'package:pocketbook/screens/book_form_screen.dart';
import 'package:pocketbook/screens/favourite_screen.dart';
import 'package:pocketbook/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("PocketBook!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("Books"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Favourites"),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(OrdersScreen.route_name);
              Navigator.of(context).pushNamed(FavouriteScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Profile"),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(OrdersScreen.route_name);
              Navigator.of(context).pushNamed(ProfileScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Add Book"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(BookFormScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

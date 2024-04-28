import 'package:flutter/material.dart';
import 'package:martialartconnect/auth/auth_page.dart';
import 'package:martialartconnect/data/firebase_service/firebase_auth.dart';
import 'package:martialartconnect/pages/login_page.dart';
import 'package:martialartconnect/pages/main_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Setting and System Usage',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ListTile(
                title: Text('Log out'),
                subtitle: Text('Language, Theme, etc.'),
                onTap: () async {
                  await Authentication().Signout();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()),);
                },
              ),
            ],
          ),
        ));
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                  ],
                ),
              );
            });
      },
    );
  }
}

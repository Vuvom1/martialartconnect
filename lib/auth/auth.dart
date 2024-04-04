import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/auth/login_or_register.dart';
import 'package:martialartconnect/pages/home_page.dart';
import 'package:martialartconnect/pages/main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return const MainPage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }

  
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:martialartconnect/components/textfild.dart';
import 'package:martialartconnect/data/firebase_service/firebase_auth.dart';
import 'package:martialartconnect/utils/dialog.dart';
import 'package:martialartconnect/utils/exception.dart';
import 'package:martialartconnect/utils/imagepicker.dart';
class RegisterPage extends StatefulWidget {
  final VoidCallback show;
  RegisterPage(this.show, {super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  File? _imageFile;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    passwordConfirme.dispose();
    username.dispose();
    bio.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset('images/logo.png', height: 200,),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () async {
                File _imagefile = await ImagePickerr().uploadImage('gallery');
                setState(() {
                  _imageFile = _imagefile;
                });
              },
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey,
                child: _imageFile == null
                    ? CircleAvatar(
                        radius: 34,
                        backgroundImage: AssetImage('images/person.png'),
                        backgroundColor: Colors.grey.shade200,
                      )
                    : CircleAvatar(
                        radius: 34,
                        backgroundImage: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ).image,
                        backgroundColor: Colors.grey.shade200,
                      ),
              ),
            ),
            SizedBox(height: 40),
            Textfild(email, email_F, 'Email', Icons.email),
            SizedBox(height: 15),
            Textfild(username, username_F, 'username', Icons.person),
            SizedBox(height: 15),
            Textfild(bio, bio_F, 'bio', Icons.abc),
            SizedBox(height: 15),
            Textfild(password, password_F, 'Password', Icons.lock),
            SizedBox(height: 15),
            Textfild(passwordConfirme, passwordConfirme_F, 'PasswordConfirme',
                Icons.lock),
            SizedBox(height: 15),
            Signup(),
            SizedBox(height: 15),
            Have()
          ],
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don you have account?  ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login ",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget Signup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirme: passwordConfirme.text,
              username: username.text,
              bio: bio.text,
              profile: _imageFile ?? File(''),
            );
          } on exceptions catch (e) {
            // ignore: use_build_context_synchronously
            if (mounted) {
            dialogBuilder(context, e.message);
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Sign up',
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  
}
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/data/firebase_service/firebase_auth.dart';
import 'package:martialartconnect/data/firebase_service/firestore.dart';
import 'package:martialartconnect/data/model/user_model.dart';
import 'package:martialartconnect/pages/main_page.dart';
import 'package:martialartconnect/utils/cached_image.dart';
import 'package:martialartconnect/utils/dialog.dart';
import 'package:martialartconnect/utils/exception.dart';
import 'package:martialartconnect/utils/imagepicker.dart';

class ProfileEditPage extends StatefulWidget {
  Usermodel user;
  ProfileEditPage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfileEditPage> {
  final TextEditingController username = TextEditingController();
  final bio = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      username.text = widget.user.username;
      bio.text = widget.user.bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit your profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
              child: Column(
            children: [
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
                      ? ClipOval(
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CachedImage(widget.user.profile)),
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
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  label: Text('User name'),
                ),
              ),
              TextField(
                controller: bio,
                decoration: InputDecoration(
                  label: Text('Bio'),
                ),
              ),

              SizedBox(
                height: 50,
              ),

              Update(),

            ],
          )),
        ),
      ),
    );
  }

  Widget Update() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          showDialog(context: context, builder: (context) {
            return const Center(child: CircularProgressIndicator(color: Colors.black,));
          });
          try {
            await Firebase_Firestor().updateUserProfile(
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

          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));

        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Update',
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

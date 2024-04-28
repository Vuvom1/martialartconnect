import 'dart:io';
import 'package:flutter/material.dart';
import 'package:martialartconnect/data/firebase_service/firestore.dart';
import 'package:martialartconnect/data/firebase_service/storage.dart';


class AddPostTextPage extends StatefulWidget {
  File _file;
  AddPostTextPage(this._file, {super.key});

  @override
  State<StatefulWidget> createState() => _AddPostTextPageState();
}

class _AddPostTextPageState extends State<AddPostTextPage> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Posts',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });
                  
                  String post_url = await StorageMethod()
                  .uploadImageToStorage('post', widget._file);
                  await Firebase_Firestor().CreatePost(
                    postImage: post_url, 
                    caption: caption.text, 
                    location: location.text
                  );
                  
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Share',
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: isloading ? const Center(
          child: CircularProgressIndicator(color: Colors.black,)
        ) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image: FileImage(widget._file),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: TextField(
                      controller: caption,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption',
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 200,
                height: 30,
                child: TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    hintText: 'Add location',
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

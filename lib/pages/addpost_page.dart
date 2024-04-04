import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/components/text_field.dart';
import 'package:martialartconnect/components/wall_post.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPostPage();
}

class _AddPostPage extends State<AddPostPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Posst'),
      ),
    );
  }
  }

// Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: MyTextField(
//                           controller: textController,
//                           hintText: "Write something on the wall",
//                           obscureText: false)),
//                   IconButton(
//                     onPressed: postMessage,
//                     icon: const Icon(Icons.arrow_circle_up),
//                   ),
//                 ],
//               ),
//             ),
//             Text("Loggged in as: ${currentUser.email!}"),
//   }
//     );
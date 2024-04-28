import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: SizedBox(
          child: Image.asset(
            './images/logo.png', 
            width: 250,
            )
        ),
        // leading: Image.asset('images/fighter.png'),
        actions: const [
          Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
            size: 25,
          ),
          SizedBox(width: 20,)
          // Image.asset(
          //   height: 25,
          //   'images/video-camera.png'),
        ],
        backgroundColor: const Color(0xffFAFAFA),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return WallPost(snapshot.data!.docs[index].data());
                    },
                    childCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

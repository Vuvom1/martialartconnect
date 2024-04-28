import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:martialartconnect/components/reel_item.dart';
import 'package:martialartconnect/components/video_item.dart';
import 'package:martialartconnect/data/firebase_service/firestore.dart';
import 'package:martialartconnect/data/model/user_model.dart';
import 'package:martialartconnect/pages/main_page.dart';
import 'package:martialartconnect/pages/menu_page.dart';
import 'package:martialartconnect/pages/post_page.dart';
import 'package:martialartconnect/pages/profileedit_page.dart';
import 'package:martialartconnect/utils/cached_image.dart';

class ProfilePage extends StatefulWidget {
  String Uid;
  ProfilePage({super.key, required this.Uid});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  bool yourse = false;
  List following = [];
  bool follow = false;

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (snap.data() != null) {
      following = (snap.data()! as dynamic)['following'];
    }
    if (following.contains(widget.Uid)) {
      setState(() {
        follow = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    if (widget.Uid == _auth.currentUser!.uid) {
      setState(() {
        yourse = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MenuPage(),
                    ));
                  },
                  child: Icon(Icons.menu_rounded),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: Firebase_Firestor().getUser(UID: widget.Uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Head(snapshot.data!);
                  },
                ),
              ),
            ],
            body: TabBarView(
              children: [
                StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('posts')
                      .where('uid', isEqualTo: widget.Uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    post_lenght = snapshot.data!.docs.length;
                    return GridView.builder(
                      itemBuilder: (context, index) {
                        final snap = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PostPage(snapshot: snap.data())));
                          },
                          child: CachedImage(
                            snap['postImage'],
                          ),
                        );
                      },
                      itemCount: post_lenght,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('reels')
                      .where('uid', isEqualTo: widget.Uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {

                      return GridView.builder(
                      itemBuilder: (context, index) {
                        final snap = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {

                          },
                          child: VideoItem(snapshot: snap.data(),)
                        );
                      },
                      itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    );
                    
                    } else if (!snapshot.hasData) {
                      return Center(child: const Text('There is no reels in your profile'));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'),);
                    }

                    return const Center(child: CircularProgressIndicator(),);
                    
                  },
                ),
                StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('posts')
                      .where('uid', isEqualTo: widget.Uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    post_lenght = snapshot.data!.docs.length;
                    return GridView.builder(
                      itemBuilder: (context, index) {
                        final snap = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PostPage(snapshot: snap.data())));
                          },
                          child: CachedImage(
                            snap['postImage'],
                          ),
                        );
                      },
                      itemCount: post_lenght,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Head(Usermodel user) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                child: ClipOval(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CachedImage(user.profile),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 35),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 53),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 70),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 19),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  user.bio,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: !follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: GestureDetector(
                onTap: () {
                  if (yourse == false) {
                    Firebase_Firestor().flollow(uid: widget.Uid);
                    setState(() {
                      follow = true;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yourse ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: yourse ? Colors.grey.shade400 : Colors.blue),
                  ),
                  child: yourse
                      ? GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileEditPage(
                                user: user,
                              ),
                            ))
                          },
                          child: Text('Edit your profile'),
                        )
                      : Text(
                          'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Firebase_Firestor().flollow(uid: widget.Uid);
                        setState(() {
                          follow = false;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text('Unfollow')),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection),
                Icon(Icons.person),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

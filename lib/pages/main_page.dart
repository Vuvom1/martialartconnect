import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/pages/addpost_page.dart';
import 'package:martialartconnect/pages/home_page.dart';
import 'package:martialartconnect/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const AddPostPage(),
    const ProfilePage()
  ];

  bool isMenuShowed = true;
  int selectedMenuItem = 0;

  final currentUser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  final emailTextController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void onTap(int index) {
    setState(() {
      selectedMenuItem = index;
    });
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: pages[selectedMenuItem],

      bottomNavigationBar: Visibility(
      visible: isMenuShowed,
      child: BottomNavigationBar(
        onTap: onTap,
        currentIndex: selectedMenuItem,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), 
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add), 
          label: 'Add new post'
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.map_outlined), 
        //   label: 'Profile'
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined), 
          label: 'Profile'
        ),
        
      ]
      )
    )
      
    );
  }
}

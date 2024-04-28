import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/pages/add_page.dart';
import 'package:martialartconnect/pages/explore_page.dart';
import 'package:martialartconnect/pages/home_page.dart';
import 'package:martialartconnect/pages/profile_page.dart';
import 'package:martialartconnect/pages/reel_page.dart';
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageStates();
}

int _currentIndex = 0;

class _NavigationPageStates extends State<NavigationPage> {
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_camera_front_outlined),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const HomePage(),
          const ExplorePage(),
          const AddPage(),
          const ReelPage(),
          ProfilePage(Uid: _auth.currentUser!.uid,),
        ],
      ),
    );
  }
}
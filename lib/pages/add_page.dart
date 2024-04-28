import 'package:flutter/material.dart';
import 'package:martialartconnect/pages/addpost_page.dart';
import 'package:martialartconnect/pages/addreel_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPageState();
}

int _currentPage = 0;

class _AddPageState extends State<AddPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _currentPage = 0;
  }

  @override 
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: const [
                AddPostPage(),
                AddReelPage(),
              ],
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 10,
              right: _currentPage == 0 ? 100 : 150,
              child: Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [
                  GestureDetector
                  (
                    onTap: () {
                      navigationTapped(0);
                    },
                    child: Text(
                      'Post', 
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w500,
                        color: _currentPage==0?Colors.white:Colors.grey,
                        ),
                      ),
                  ),

                  GestureDetector(
                    onTap: () {
                      navigationTapped(1);
                    },
                    child: Text(
                      'Reels', 
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w500,
                        color: _currentPage==1?Colors.white:Colors.grey,
                        ),
                      ),
                  ),

                ],),
              ),
            )

          ],
        ),
      ),
    );
  }
}

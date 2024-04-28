import 'package:flutter/material.dart';
import 'package:martialartconnect/components/post_widget.dart';
import 'package:martialartconnect/components/wall_post.dart';

class PostPage extends StatelessWidget {
  final snapshot;

  const PostPage({super.key, this.snapshot});


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(

        child: Center(child: WallPost(snapshot))),
    );
  }

}
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:martialartconnect/components/comment.dart';
import 'package:martialartconnect/components/like_animation.dart';
import 'package:martialartconnect/data/firebase_service/firestore.dart';
import 'package:martialartconnect/pages/profile_page.dart';
import 'package:martialartconnect/utils/cached_image.dart';

class WallPost extends StatefulWidget {
  final snapshot;

  const WallPost(this.snapshot, {super.key});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  bool isAnimating = false;

  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 425,
          height: 54,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
              title: GestureDetector(
                onTap: () => {
                   Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(Uid: widget.snapshot['uid']),
                                  ))
                },
                child: Text(
                  widget.snapshot['username'],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestor().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 425,
                height: 425,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 425,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Row(
                children: [
                  const SizedBox(width: 14),
                  LikeAnimation(
                    isAnimating: widget.snapshot['like'].contains(user),
                    child: IconButton(
                      onPressed: () {
                        Firebase_Firestor().like(
                            like: widget.snapshot['like'],
                            type: 'posts',
                            uid: user,
                            postId: widget.snapshot['postId']);
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      top: 4,
                      bottom: 8,
                    ),
                    child: Text(
                      widget.snapshot['like'].length.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.6,
                              minChildSize: 0.2,
                              builder: (context, scrollController) {
                                return Comment(
                                    'posts', widget.snapshot['postId']);
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'images/comment.png',
                      height: 28,
                    ),
                  ),
                  SizedBox(width: 17),
                  Image.asset(
                    'images/send.png',
                    height: 28,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      'images/save.png',
                      height: 28,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.snapshot['username'] +
                            ' :  ' +
                            widget.snapshot['caption'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
                child: Text(
                  formatDate(widget.snapshot['time'].toDate(),
                      [yyyy, '-', mm, '-', dd]),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

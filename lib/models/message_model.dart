// import 'package:flutter';

import 'package:martialartconnect/models/user_model.dart';

class Message  {
  final String sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });
}

final User currentUser = User(
  id: 0, 
  name: 'Current User', 
  imageUrl: 'assets/images/greg.jpg',
);

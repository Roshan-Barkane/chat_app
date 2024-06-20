import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';

import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  final ChatUser user;
  const chatUserCard({super.key, required this.user});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // user pic
          leading: const CircleAvatar(child: Icon(Icons.person)),

          // user name
          title: Text(
            widget.user.name,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),

          // user last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          // message time are show
          trailing: const Text(
            "05:47 AM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

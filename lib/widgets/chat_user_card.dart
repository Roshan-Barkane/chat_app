import 'package:chat_app/main.dart';

import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  const chatUserCard({super.key});

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
        child: const ListTile(
          // user pic
          leading: CircleAvatar(child: Icon(Icons.person)),

          // user name
          title: Text("User Name"),

          // user last message
          subtitle: Text(
            "Last user massage",
            maxLines: 1,
          ),

          // message time are show
          trailing: Text(
            "05:47 AM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

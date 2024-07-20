import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/page/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        onTap: () {
          // for navigating chat screen
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: ListTile(
            // user pic
            //leading: const CircleAvatar(child: Icon(Icons.person)),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .03),
              // cachedNetworkImage are used to dynamic load image
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),

            // user name
            title: Text(
              widget.user.name,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),

            // user last message
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),

            // message time are show
            trailing: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  borderRadius: BorderRadius.circular(10)),
            )
            /*trailing: const Text(
            "05:47 AM",
            style: TextStyle(color: Colors.black54),
          ),*/
            ),
      ),
    );
  }
}

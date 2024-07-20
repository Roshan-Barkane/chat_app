import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // for custom app bar
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        // for call the _appBar function
        flexibleSpace: _appBar(),
      ),
    );
  }

// for create a function make the app bar demand clint
  Widget _appBar() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            // for make button
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
            // for profile picture in current user chat me
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .03),
              // cachedNetworkImage are used to dynamic load image
              child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // for show the user name and last seen updata come to online
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // show the user name you are chat us
                Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                // for adding some space
                const SizedBox(
                  height: 2,
                ),
                // for show last time and data online for person
                const Text(
                  "Last seen not updata",
                  style: TextStyle(fontSize: 15, color: Colors.white60),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

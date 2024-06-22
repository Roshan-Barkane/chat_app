import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/api.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text(
          "Profile Screen",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue.shade400,
        toolbarHeight: 80,
      ),

      // floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(
            Icons.add_comment,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .5),
        child: Column(
          children: [
            // for adding some space
            SizedBox(
              width: mq.width,
              height: mq.height * .05,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              // cachedNetworkImage are used to dynamic load image
              child: CachedNetworkImage(
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.fill,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
            // for adding some space
            SizedBox(
              width: mq.width,
              height: mq.height * .05,
            ),
            Text(
              widget.user.email,
              style: const TextStyle(color: Colors.black87, fontSize: 20),
            ),
            TextFormField(
              initialValue: widget.user.name,
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:chat_app/helper/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api.dart';
 */

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // app bar
        appBar: AppBar(
          title: Text(
            widget.user.name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.blue.shade400,
          toolbarHeight: 80,
        ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 40,
              child: Text(" "),
            ),
            const Text(
              "Joined On :",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              MyDataUtil.getLastMessageTime(
                  context: context,
                  lastActive: widget.user.createdAt,
                  showYear: true),
              style: const TextStyle(color: Colors.black38, fontSize: 15),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
          child: SingleChildScrollView(
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
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
                // for adding some space
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),
                // show email from the current user
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                // for adding some space
                SizedBox(
                  height: mq.height * .02,
                ),
                // show email from the current user
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "About :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.user.about,
                      style:
                          const TextStyle(color: Colors.black38, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

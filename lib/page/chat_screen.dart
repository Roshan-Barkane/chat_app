import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/massage.dart';
import 'package:chat_app/page/massage_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  List<Massage> _list = [];

  Widget build(BuildContext context) {
    return Scaffold(
      // for custom app bar
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        // for call the _appBar function
        flexibleSpace: _appBar(),
      ),
      // body
      backgroundColor: Color.fromARGB(255, 215, 212, 255),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              // stream are takes to which point to come data
              stream: APIs.getAllMessages(),
              //stream: Stream.value(_list[0]),
              builder: (context, snapshot) {
                /* condition at if any user don't chat and if data are not loaded. */
                // connection State say data are loading and loaded.
                switch (snapshot.connectionState) {
                  // if data are loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                  // if some add all the data are loaded.
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    debugPrint("Data :${jsonEncode(data![0].data())}");
                    // its work on for loop pic one by one data store the list
                    /*_list =
                        data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                            [];*/
                    // add dummy contain in list
                    _list.clear();
                    _list.add(Massage(
                        toid: 'xyz',
                        msg: 'hii',
                        read: '',
                        type: Type.text,
                        send: '12:00 AM',
                        fromid: APIs.user.uid));
                    _list.add(Massage(
                        toid: APIs.user.uid,
                        msg: 'Hello',
                        read: '',
                        type: Type.text,
                        send: '01:00 PM',
                        fromid: 'xyz'));

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const BouncingScrollPhysics(),
                        // check item are present _searchList then use _searchList otherwise use _list
                        itemCount: _list.length,
                        itemBuilder: ((context, index) {
                          return MassageCard(
                            message: _list[index],
                          );
                        }),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Say Hii 👋🏻",
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }
                }
              },
            ),
          ),
          _chatInput(),
          const SizedBox(height: 45),
        ],
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
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
            // for profile picture in current user chat me
            InkWell(
              onTap: () {},
              child: ClipRRect(
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

  // for chat input function
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.height * .02, vertical: mq.width * .01),
      child: Row(
        children: [
          // for input field and buttons
          Expanded(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                // for button emojis show
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        size: 29,
                        color: Colors.blue,
                      )),
                  // for textfield write the text
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Text Something...",
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                    ),
                  ),
                  // for button pic image local device
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        size: 29,
                        color: Colors.blue,
                      )),
                  // for pic the image form camera
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        size: 29,
                        color: Colors.blue,
                      )),
                  // for adding some space
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),

          // for send message button
          MaterialButton(
              onPressed: () {},
              shape: const CircleBorder(),
              minWidth: 0,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 5, left: 10),
              color: Colors.blue,
              child: const Icon(
                Icons.send,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/massage.dart';
import 'package:chat_app/page/massage_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all message
  List<Massage> _list = [];

  // for handling message text changes
  final _textController = TextEditingController();

  // for storing value of show and hidden emoji
  bool _showEmoji = false;

  @override
// for handling message text changes
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // if emoji are show  & back button is pressed then hidden keyboards.
        // or else simple close the current Screen on click back button
        onWillPop: () {
          /*Called to veto attempts by the user to dismiss the enclosing [ModalRoute].
            If the callback returns a Future that resolves to false, the enclosing route will not be popped */
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            // for custom app bar
            appBar: AppBar(
              toolbarHeight: 75,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              // for call the _appBar function
              flexibleSpace: _appBar(),
            ),
            // body
            backgroundColor: const Color.fromARGB(255, 215, 212, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    // stream are takes to which point to come data
                    stream: APIs.getAllMessages(widget.user),
                    //stream: Stream.value(_list[0]),
                    builder: (context, snapshot) {
                      /* condition at if any user don't chat and if data are not loaded. */
                      // connection State say data are loading and loaded.
                      switch (snapshot.connectionState) {
                        // if data are loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(child: SizedBox());

                        // if some add all the data are loaded.
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          // its work on for loop pic one by one data store the list
                          _list = data!
                              .map((e) => Massage.fromJson(e.data()))
                              .toList();

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
                // const SizedBox(height: 45),

                // show emoji on  keyboards emoji button chick & voice vector
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .33,
                    child: EmojiPicker(
                      textEditingController:
                          _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        columns: 8,
                        //enableSkinTones: true,
                        // bgColor: const Color(0xFFF2F2F2),
                        //checkPlatformCompatibility: true,

                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
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
            // for show the user name and last seen update come to online
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
                  "Last seen not update",
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        size: 29,
                        color: Colors.blue,
                      )),
                  // for textfield write the text
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
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
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 5, right: 5, left: 10),
            color: Colors.blue,
            child: const Icon(
              Icons.send,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

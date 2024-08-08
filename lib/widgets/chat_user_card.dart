import 'package:chat_app/api/api.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/page/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../models/massage.dart';

class chatUserCard extends StatefulWidget {
  final ChatUser user;
  const chatUserCard({super.key, required this.user});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  // create Massage object
  // last message info (if null ---> no message)
  Massage? _massage;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            // for navigating chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Massage.fromJson(e.data())).toList();
              if (list != null && list.isNotEmpty) {
                // fetch the data from Firebase to local _massage object
                _massage = list[0];
              } else {
                // handle the case where list is null or empty
                print('List is null or empty');
              }
              /*if (list!.isNotEmpty) {
                // fetch the data form firebase to local massage object
                _massage = list[0];
              }*/
              return ListTile(
                // user pic
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
                  //widget.user.about,
                  // _massage?.msg ?? widget.user.about,
                  _massage != null
                      ? _massage?.type == Type.image
                          ? "image"
                          : _massage!.msg
                      : widget.user.about,
                  maxLines: 1,
                ),

                // message time are show
                trailing: _massage == null
                    ? null
                    : _massage!.read.isEmpty &&
                            _massage!.fromid != APIs.user.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade700,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(
                            MyDataUtil.getLastMessageTime(
                                context: context, time: _massage!.send),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}

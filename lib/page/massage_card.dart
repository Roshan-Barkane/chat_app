import 'package:chat_app/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/massage.dart';

class MassageCard extends StatefulWidget {
  const MassageCard({super.key, required this.message});
  final Massage message;

  @override
  State<MassageCard> createState() => _MassageCardState();
}

class _MassageCardState extends State<MassageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromid
        ? _greenMessage()
        : _blueMessage();
  }

  // Sender or another user massage
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(mq.width * .04),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 237, 253),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              border: Border.all(color: Colors.blue.shade300)),
          child: Text(
            widget.message.msg +
                "if context are long then come to error of message overflow and app is not seeble",
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        // show the time massage
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            widget.message.send,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // our or user massage
  Widget _greenMessage() {
    return Container();
  }
}

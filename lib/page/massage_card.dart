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
        Flexible(
          child: Container(
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
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        // show the time massage
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04, left: mq.width * .05),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            // double click blue icon massage read
            const Icon(
              Icons.done_all_outlined,
              color: Colors.blue,
              size: 19,
            ),
            // for adding some space
            const SizedBox(
              width: 2,
            ),
            // show the time massage
            Text(
              "${widget.message.read}04:21 PM",
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 192, 255, 194),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                border: Border.all(color: Colors.green)),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
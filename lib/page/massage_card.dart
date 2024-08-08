import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
    // update last read message if sender and receiver are different.
    if (widget.message.read.isEmpty) {
      // pass the message from update messageReadStatus
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                widget.message.type == Type.image ? 10 : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 217, 237, 253),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                border: Border.all(color: Colors.blue.shade300)),
            child: widget.message.type == Type.text
                //  show the text in chatScreen
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                :
                //  show the image in chatScreen
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // cachedNetworkImage are used to dynamic load image
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        // show the time massage
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04, left: mq.width * .05),
          child: Text(
            MyDataUtil.getFormattedTime(
                context: context, time: widget.message.send),
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
            if (widget.message.read.isNotEmpty)
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
              MyDataUtil.getFormattedTime(
                  context: context, time: widget.message.send),
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                widget.message.type == Type.image ? 10 : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 192, 255, 194),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                border: Border.all(color: Colors.green)),
            child: widget.message.type == Type.text
                //  show the text in chatScreen
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                :
                //  show the image in chatScreen
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // cachedNetworkImage are used to dynamic load image
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

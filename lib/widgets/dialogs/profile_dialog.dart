import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/page/view_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .5,
        height: mq.height * .35,
        child: Stack(
          children: [
            // for show user name
            Positioned(
              top: mq.height * .02,
              left: mq.width * .05,
              width: mq.width * .55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            // for show the user picture
            Positioned(
              top: mq.height * .075,
              left: mq.width * .13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .4),
                // cachedNetworkImage are used to dynamic load image
                child: CachedNetworkImage(
                  width: mq.height * .23,
                  height: mq.height * .23,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
            ),
            // for show the button go to view profile screen
            Positioned(
              right: 8,
              top: 6,
              child: SizedBox(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

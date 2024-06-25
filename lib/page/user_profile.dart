import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
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
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            //shape: const CircleBorder(),
            onPressed: () async {
              // for show progress bar
              Dialogs.showProgessBar(context);

              // sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // for remove progress var
                  Navigator.pop(context);

                  // for moving to home page
                  Navigator.pop(context);

                  // replacing home page to login page
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                });
              });
            },
            icon: const Icon(
              Icons.logout_rounded,
              size: 25,
              color: Colors.white,
            ),
            label: const Text(
              "LogOut",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
          child: Column(
            children: [
              // for adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .05,
              ),
              Stack(
                children: [
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
                  // edit image button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      elevation: 2,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              // for adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .03,
              ),
              // show email from the current user
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
              // for adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .05,
              ),
              // for user name field
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                    hintText: "eg. Happy Singh",
                    label: const Text("Name")),
              ),
              // for adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .02,
              ),
              // for user about field
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.info_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
                  label: const Text("About"),
                  hintText: "eg. Felling Happy",
                ),
              ),
              // for adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .02,
              ),
              // update button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: const StadiumBorder(),
                  minimumSize: Size(mq.width * .05, mq.height * .06),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 28,
                ),
                label: const Text(
                  "Update",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

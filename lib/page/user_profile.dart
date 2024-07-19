import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

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
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      // for remove progress var
                      Navigator.pop(context);

                      // for moving to home page
                      Navigator.pop(context);

                      // replacing home page to login page
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                  );
                },
              );
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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ?
                          // Local image show the profile Picture
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              // cachedNetworkImage are used to dynamic load image
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          :

                          // Server image are show Profile Picture
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              // cachedNetworkImage are used to dynamic load image
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(Icons.person)),
                              ),
                            ),
                      // edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomsheet();
                          },
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
                    // get the value textfield to api self variable
                    onSaved: (newVal) => APIs.me.name = newVal ?? "",
                    // check the validate user textfield are text or empty
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required text",
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
                    // get the value textfield to api self variable
                    onSaved: (newVal) => APIs.me.about = newVal ?? "",
                    // check the validate user textfield are text or empty
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required text",
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        // debugPrint("inside Volidater !");
                        APIs.updateUserInfo().then(
                          (value) {
                            Dialogs.showSnackBar(
                                context, 'Profile Update Successfully !');
                          },
                        );
                      }
                    },
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
        ),
      ),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomsheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (_) {
        return ListView(
          /* shrinkWrap property : This constructor is appropriate for list views with a small number of children because constructing the [List] requires doing work for every child that could possibly be displayed in the list view instead of just those children that are actually visible. */
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .08),
          children: [
            // pick profile picture label
            const Text(
              "Pick Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: mq.height * .02),
            // buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // pick image form gallery button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // fixedSize take a size on width ans height
                      fixedSize: Size(mq.width * .3, mq.height * .14)),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      debugPrint(
                          " Image Path :${image.path} --MimeType :${image.mimeType}");
                      setState(() {
                        _image = image.path;
                      });
                      // call the updataProfilePicture
                      APIs.updateProfilePicture(File(_image!));
                      // for hiding bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    "images/gallery.png",
                  ),
                ),
                // take image form Camera button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // fixedSize take a size on width ans height
                      fixedSize: Size(mq.width * .3, mq.height * .14)),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      debugPrint(" Image Path :${image.path} ");
                      setState(() {
                        _image = image.path;
                      });
                      // call the updataProfilePicture
                      APIs.updateProfilePicture(File(_image!));
                      // for hiding bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    "images/photo.png",
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add the dynamic data into list
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // app bar
        appBar: AppBar(
          /*leading: const Icon(
          Icons.home,
          color: Colors.white,
        ),*/
          title: const Text(
            "Chatting app",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.blue.shade400,
          toolbarHeight: 80,
          actions: [
            // search button serach the person
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            // more feature button
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                )),
          ],
        ),
        drawer: const Drawer(),
        // floating action button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(
              Icons.add_comment,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder(
          // stream are takes to which point to come data
          stream: APIs.firestore.collection("usres").snapshots(),
          builder: (context, snapshot) {
            /* condition at if any user don't chat and if data are note loaded . */
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
                // its work on for loop pic one by one data store the list
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 16,
                    itemBuilder: ((context, index) {
                      // return const chatUserCard();
                      return Text("Name : ${list[index]}");
                    }));
            }

            // check the collaction are present or not
          },
        ));
  }
}

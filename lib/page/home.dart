import 'dart:convert';
// im
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/page/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/api.dart';
import '../widgets/chat_user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add the dynamic data into list
  List<ChatUser> _list = [];
  // for store searching items
  final List<ChatUser> _serchList = [];

  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        /*leading: const Icon(
          Icons.home,
          color: Colors.white,
        ),*/
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name, Email ...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
                autofocus: true,
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 0.5, color: Colors.white),
                // when search text change then update search list
                onChanged: (value) {
                  // search logic
                  _serchList.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(value.toUpperCase()) ||
                        i.email.toLowerCase().contains(value.toUpperCase())) {
                      _serchList.add(i);
                    }
                    setState(() {
                      _serchList;
                    });
                  }
                },
              )
            : const Text(
                "Chatting app",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
        backgroundColor: Colors.blue.shade400,
        toolbarHeight: 80,
        actions: [
          // search button serach the person
          IconButton(
              onPressed: () {
                setState(() {
                  // store apposite value
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                _isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search,
                color: Colors.white,
              )),
          // more feature button
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(user: APIs.me),
                  ),
                );
              },
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
            // await APIs.auth.signOut();
            // await GoogleSignIn().signOut();
            setState(() {});
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
        stream: APIs.getAllUser(),
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
              _list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              if (_list.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: ((context, index) {
                    return chatUserCard(user: _list[index]);
                    //return Text("Name : ${list[index]}");
                  }),
                );
              } else {
                return const Center(
                  child: Text(
                    "No Connection Found !",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

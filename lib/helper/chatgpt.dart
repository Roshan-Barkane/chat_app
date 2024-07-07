import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/page/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final List<ChatUser> _searchList = [];

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
                onChanged: (val) {
                  // search logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(val.toUpperCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                  }

                  setState(() {
                    // update the UI after searching
                  });
                },
              )
            : const Text(
                "Chatting app",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
        backgroundColor: Colors.blue.shade400,
        toolbarHeight: 80,
        actions: [
          // search button search the person
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
          /* condition at if any user don't chat and if data are not loaded. */
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
                  // check item are present _searchList then use _searchList otherwise use _list
                  itemCount: _isSearching ? _searchList.length : _list.length,
                  itemBuilder: ((context, index) {
                    return chatUserCard(
                        user: _isSearching ? _searchList[index] : _list[index]);
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

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            // add the dynamic data into list
            final list = [];
            // check the collaction are present or not
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              for (var i in data!) {
                print('Data : ${i.data()}');
                // add data into list
                list.add(i.data()['name']);
              }
            } else {
              debugPrint("Don't come to data into firebase firestore");
            }
            return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: 16,
                itemBuilder: ((context, index) {
                  // return const chatUserCard();
                  return Text("Name : ${list[index]}");
                }));
          },
        ));
  }
}

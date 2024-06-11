import 'package:flutter/material.dart';

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
        leading: const Icon(Icons.home),
        title: const Text("Chatting app"),
        actions: [
          // search button serach the person
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          // more feature button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      // floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(
            Icons.add_comment,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: const Text("Run fist time"),
      ),
    );
  }
}

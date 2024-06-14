import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        // app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Wellcome to Chatting App"),
        ),
        body: Stack(
          children: [
            Positioned(
              // mq.height * .15 means top to icon padding is 15%.
              top: mq.height * .15,
              width: mq.width / 1.4, // 50% width of Image.
              left: mq.width * .15, //   25% left padding.
              child: Image.asset("images/cloud-messaging.png"),
            ),
            Positioned(
              bottom: mq.height * .14,
              width: mq.width * .9, // 50% width of Image.
              left: mq.width * .05, //   25% left padding.
              height: mq.height * .07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, elevation: 1),
                onPressed: () {},
                icon: Image.asset("images/search.png"),
                label: const Text("Signin with Google"),
              ),
            ),
          ],
        ));
  }
}

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
              height: mq.height * .06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 199, 239, 153),
                    elevation: 1),
                onPressed: () {},
                icon: Image.asset(
                  "images/search.png",
                  height: mq.height * .04, // MediaQuery
                ),
                label: RichText(
                  text: const TextSpan(children: [
                    TextSpan(text: "SignIn with "),
                    TextSpan(
                        text: "Google",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ], style: TextStyle(color: Colors.black, fontSize: 17)),
                ),
              ),
            ),
          ],
        ));
  }
}

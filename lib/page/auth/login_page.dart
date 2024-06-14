import 'package:chat_app/main.dart';
import 'package:chat_app/page/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // one time animate the icon using Future class with duration
    Future.delayed(
      Duration(milliseconds: 300),
      () {
        setState(
          () {
            _isAnimate = true;
          },
        );
      },
    );
  }

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
          // app logo
          AnimatedPositioned(
            // mq.height * .15 means top to icon padding is 15%.
            top: mq.height * .15,
            width: mq.width / 1.4, // 50% width of Image.
            right: _isAnimate
                ? mq.width * .15
                : -mq.height * .5, //   25% left padding.
            duration: const Duration(seconds: 1),
            child: Image.asset("images/cloud-messaging.png"),
          ),
          // sing-in button.
          Positioned(
            bottom: mq.height * .14,
            width: mq.width * .9, // 50% width of Image.
            left: mq.width * .05, //   25% left padding.
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 199, 239, 153),
                elevation: 1,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
              },
              icon: Image.asset(
                "images/search.png",
                height: mq.height * .04, // MediaQuery
              ),
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "Login with "),
                    TextSpan(
                      text: "Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

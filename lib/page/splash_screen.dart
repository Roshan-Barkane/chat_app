import 'package:chat_app/main.dart';
import 'package:chat_app/page/auth/login_page.dart';
import 'package:chat_app/page/home.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // one time animate the icon using Future class with duration
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // app logo
          Positioned(
            // mq.height * .15 means top to icon padding is 15%.
            top: mq.height * .15,
            width: mq.width / 1.4, // 50% width of Image.
            right: mq.width * .15, //   25% left padding.

            child: Image.asset("images/cloud-messaging.png"),
          ),
          // sing-in button.
          Positioned(
            bottom: mq.height * .15,
            width: mq.width, // 50% width of Image.

            child: const Text(
              "MADE OF INDIA WITH JACK ❤",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87, fontSize: 16, letterSpacing: .5),
            ),
          ),
        ],
      ),
    );
  }
}

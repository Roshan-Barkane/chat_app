// import 'package:chat_app/page/home.dart';
import 'package:chat_app/page/auth/login_page.dart';
import 'package:chat_app/page/splash_screen.dart';
import 'package:flutter/material.dart';
//import 'page/auth/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

// global object accessing device screen size
late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // for setting orientation for portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (value) {
      _initializeFirebase();
      runApp(const MyApp());
    },
  );
  // _initializeFirebase();
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'my khusi',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 1,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          )),
      // switch the main screen.
      home: SplashPage(),
    );
  }
}

// initialize the firebase
_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

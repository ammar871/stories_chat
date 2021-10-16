import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:stories_chat/helper/cemmon.dart';
import 'package:stories_chat/helper/constans.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  late FirebaseMessaging messaging;

  String? _token;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
      Cemmen.userToken = token!;
    });
  }

  void navigationPage() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print("null");
        Navigator.of(context).pushReplacementNamed(welcome);
      } else {
        print("home");
        Navigator.of(context).pushReplacementNamed(home);
      }
    });
  }

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    setState(() {});

    startTime();
  }

  // Future<void> requestPermion() async {
  //    if (await Permission.contacts.request().isGranted) {
  //   // Either the permission was already granted before or the user just granted it.
  //   }
  //
  //   // You can request multiple permissions at once.
  //   Map<Permission, PermissionStatus> statuses = await [
  //   Permission.contacts,
  //   Permission.storage,
  //   ].request();
  //
  //    if (await Permission.speech.isPermanentlyDenied) {
  //      // The user opted to never again see the permission request dialog for this
  //      // app. The only way to change the permission's status now is to let the
  //      // user manually enable it in the system settings.
  //      openAppSettings();
  //    }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/logo.jpg",
          height: 200,
          width:200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

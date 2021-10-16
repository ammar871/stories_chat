import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/screens/login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
 static String id ="WelcomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Text(
              "مرحبا بك في حكاوى ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 290,
              width: 290,
              child: Image.asset("assets/images/logo.jpg"),
            ),
            Column(
              children: <Widget>[
                const Text(
                  "اقرأ سياسة الخصوصية الخاصة بنا ، انقر فوق موافق ومتابعة  لقبول شروط الخدمة",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(loginScreen);
                  },
                  child: const Text(
                    "موافقة ومتابعة",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

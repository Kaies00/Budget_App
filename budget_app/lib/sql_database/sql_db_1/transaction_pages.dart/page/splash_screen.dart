import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:budget_app/sql_database/sql_db_1/transaction_pages.dart/page/root_page.dart';
import 'package:flutter/material.dart';

import '../../../../budget_tracker/pages/values.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const RootTransactionPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentPinkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/3d7.webp")),
              )),
          AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
            TyperAnimatedText(
              'Notes & Tasks',
              speed: const Duration(milliseconds: 100),
              textStyle: const TextStyle(
                color: plumColor,
                fontFamily: "Valid_Harmony",
                fontSize: 30,
              ),
            ),
          ])
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:participate/screens/home/sign_out/splash/splash_screen_sign_out.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/utils/constant.dart';

Widget? AnimatedSignOut(context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SplashScreenSignOut(),
    ),
  );
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    pageIndex = 1;
    return await auth.signOut();
  }
}

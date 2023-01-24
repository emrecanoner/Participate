import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/login/login_screen.dart';
import 'package:participate/utils/constant.dart';

class SplashScreenSignUp extends StatelessWidget {
  const SplashScreenSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/jsonFiles/event.json"),
      splashIconSize: gHeight / 4,
      backgroundColor: Colors.white,
      nextScreen: LoginScreen(),
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:participate/screens/profile/profile_page.dart';
import 'package:participate/utils/constant.dart';

class SplashScreenProfile extends StatelessWidget {
  const SplashScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/jsonFiles/event.json"),
      splashIconSize: gHeight / 4,
      backgroundColor: Colors.white,
      nextScreen: ProfilePage(),
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

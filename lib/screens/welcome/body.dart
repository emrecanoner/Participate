import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:participate/screens/login/login_screen.dart';
import 'package:participate/screens/login/otp/otp_screen.dart';
import 'package:participate/screens/sign_up/sign_up_page.dart';
import 'package:participate/screens/sign_up/body_sign_up.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/images.dart';
import 'package:participate/utils/texts.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(27),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(WelcomeImage),
              height: gHeight * 0.4,
            ),
            Column(
              children: [
                Text(
                  WelcomeTitle,
                  style: styleOnBoardTitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  WelcomeSubTitle,
                  style: styleOnBoardSubTitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: mainColor,
                      side: BorderSide(color: mainColor),
                      padding: EdgeInsets.symmetric(vertical: gHeight / 50),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                    child: Text(
                      'Login'.toUpperCase(),
                    ),
                  ),
                ),
                SizedBox(width: gWidth / 80),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                      side: BorderSide(color: Colors.white, width: 0),
                      padding: EdgeInsets.symmetric(vertical: gHeight / 50),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    ),
                    child: Text(
                      'Sign Up'.toUpperCase(),
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

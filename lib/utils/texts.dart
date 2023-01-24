import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:participate/screens/login/otp/utils.dart';
import 'package:participate/utils/constant.dart';

const OnBoardTitle1 = "Socialize";
const OnBoardTitle2 = "Meet Up";
const OnBoardTitle3 = "Have Fun";

const OnBoardSubTitle1 =
    "Let's socialize by creating an event \nor participating to an event";
const OnBoardSubTitle2 = "Let's meet up with people";
const OnBoardSubTitle3 =
    "Let's have a fun by doing, watching, \neating, drinking etc something together";

const OnBoardCounter1 = "1/3";
const OnBoardCounter2 = "2/3";
const OnBoardCounter3 = "3/3";

const WelcomeTitle = "Build Awesome Events";
const WelcomeSubTitle =
    "Let's create an account and \nstart your social journey";

const LoginTitle = "Welcome Back";
const LoginSubTitle = "Sign in with your phone number";
const LoginDontHaveAnAccount = "Don't have an account? ";

const OTPTitle = 'CO\nDE';
const OTPSubTitle = 'VERIFICATION';
String OTPMessage =
    'Enter the verification code sent at\n+90 ${phoneN.text.trim()}';

const SignUpTitle = "Get on Board!";
const SignUpSubTitle = "Create your profile and start your journey";
const SignUpAlreadyHaveAnAccount = "Already have an account? ";

TextStyle styleOnBoardTitle = GoogleFonts.montserrat(
  color: Colors.black87,
  textStyle: TextStyle(
    fontSize: 25,
  ),
);

TextStyle styleOnBoardSubTitle = GoogleFonts.poppins(
    color: Colors.black54,
    textStyle: TextStyle(
      fontSize: 13,
    ));

TextStyle styleOnBoardCounter = GoogleFonts.poppins(
    color: Colors.black87,
    textStyle: TextStyle(
      fontSize: 12,
    ));

TextStyle styleAlreadyHaveAnAcooount = GoogleFonts.poppins(
    color: Colors.blue,
    textStyle: TextStyle(
      fontSize: 13,
    ));

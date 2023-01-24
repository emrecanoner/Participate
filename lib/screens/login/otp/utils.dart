import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:participate/screens/home/home_page.dart';
import 'package:participate/screens/login/otp/body.dart';
import 'package:participate/screens/login/otp/otp_screen.dart';
import 'package:participate/screens/login/splash/splash_screen_login.dart';
import 'package:participate/screens/sign_up/utils.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../welcome/welcome_screen.dart';

TextEditingController OTPController = new TextEditingController(text: "");
StreamController<ErrorAnimationType>? errorController;
String currentText = "";
BoxDecoration get _pinPutDecoration {
  return BoxDecoration(
    border: Border.all(color: iconColor),
    borderRadius: BorderRadius.circular(15.0),
  );
}

String verificationID = "";
TextEditingController phoneN = TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;

FocusNode phoneFocus = FocusNode();

int secondsRemaining = 120;
Duration myDuration = Duration(seconds: 120);
bool enableResend = false;
Timer? timer;
int numLength = 0;
bool completeNum = false;

void loginWithPhone(BuildContext context) async {
  auth.verifyPhoneNumber(
      phoneNumber: "+90" + phoneN.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          messenger(context, 'Please try again.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        registerVisibility = false;
        verificationID = verificationId;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Body()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 120));
}

void verifyOTP(BuildContext context) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID, smsCode: currentText);
  if (credential.smsCode.toString().length == 0) {
    messenger(context, 'You must enter OTP number, write it immediately.');
  } else if (credential.smsCode.toString().length < 6 &&
      credential.smsCode.toString().length > 0) {
    messenger(
        context, 'You entered missing OTP number, correct it immediately.');
  } else {
    try {
      await auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreenLogin(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        messenger(context, "OTP number doens't match, correct it immediately.");
      } else if (e.code == 'invalid-verification-id') {
        messenger(context, "OTP number doens't match, correct it immediately.");
      }
    } catch (e) {
      messenger(context, "OTP number doens't match, correct it immediately.");
    }
  }
}

void resendSMSCode(String phoneNumber, BuildContext context) async {
  auth.verifyPhoneNumber(
    phoneNumber: "+90" + phoneN.text.trim(),
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential).then((value) {
        print("You are logged in successfully");
      });
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        messenger(context, 'Please try again.');
      }
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
    codeSent: (String verificationId, int? resendToken) {
      registerVisibility = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Body(),
        ),
      );
    },
    timeout: const Duration(seconds: 120),
  );
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:participate/screens/login/otp/utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/texts.dart';

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      OTPController.clear();
      myDuration = Duration(seconds: 120);
      enableResend = false;
      numLength = 0;
      completeNum = false;
      startTimer();
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => timer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          final seconds = myDuration.inSeconds - reduceSecondsBy;
          if (seconds < 0) {
            timer!.cancel();
            enableResend = true;
          } else {
            myDuration = Duration(seconds: seconds);
          }
        });
      }
    });
  }

  void dispose() {
    super.dispose();
  }

  verifyCode() {
    verifyOTP(context);
  }

  resendCode() {
    resendSMSCode("+90" + phoneN.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(27),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    OTPTitle,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    OTPSubTitle,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  SizedBox(height: gHeight * 0.04),
                  Text(
                    OTPMessage,
                    style: GoogleFonts.poppins(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: gHeight * 0.04),
                  PinCodeTextField(
                    autoDisposeControllers: false,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    validator: (v) {},
                    pinTheme: PinTheme(
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.red,
                      disabledColor: Colors.white,
                      selectedColor: iconColor,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: iconColor,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: OTPController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                      completeNum = true;
                    },
                    onChanged: (value) {
                      Future.delayed(Duration.zero, () {
                        debugPrint(value);
                        setState(() {
                          numLength++;
                          completeNum = false;
                          currentText = value;
                        });
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                  SizedBox(height: gHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.alarm,
                        color: enableResend ? Colors.red : Colors.black,
                        size: 25,
                      ),
                      SizedBox(
                        width: gWidth / 150,
                      ),
                      Text(
                        "${myDuration.inSeconds}",
                        style: GoogleFonts.montserrat(
                            color: enableResend ? Colors.red : Colors.black,
                            fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: gHeight * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(),
                        foregroundColor: enableResend
                            ? Colors.white
                            : (completeNum ? Colors.white : Colors.black),
                        backgroundColor: enableResend
                            ? Colors.black
                            : (completeNum ? iconColor : Colors.grey),
                        side: BorderSide(color: Colors.white, width: 0),
                        padding: EdgeInsets.symmetric(vertical: gHeight / 50),
                      ),
                      onPressed: enableResend
                          ? resendCode
                          : (completeNum ? verifyCode : null),
                      child: Text(enableResend ? 'RESEND' : 'VERIFY'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masked_text/masked_text.dart';
import 'package:participate/screens/login/otp/utils.dart';
import 'package:participate/screens/sign_up/sign_up_page.dart';
import 'package:participate/screens/sign_up/utils.dart';
import 'package:participate/screens/welcome/welcome_screen.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/custom_snackbar.dart';
import 'package:participate/utils/images.dart';
import 'package:participate/utils/texts.dart';

import 'otp/otp_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    setState(() {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      phoneFocus = FocusNode();
    });
    if (mounted) {
      phoneN.clear();
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(LoginImage),
                    height: gHeight * 0.3,
                  ),
                  SizedBox(height: gHeight * 0.02),
                  Text('PARTICIPATE',
                      style: GoogleFonts.poppins(
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: <Color>[
                                mainColor,
                                mainColor,
                                mainColor,
                                mainColor,
                                iconColor,
                              ],
                            ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                    LoginTitle,
                    style: styleOnBoardTitle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    LoginSubTitle,
                    style: styleOnBoardSubTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: gHeight * 0.015),
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaskedTextField(
                            onTap: _requestFocus,
                            focusNode: phoneFocus,
                            mask: "### ### ## ##",
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 13,
                            controller: phoneN,
                            showCursor: false,
                            decoration: InputDecoration(
                              counter: Offstage(),
                              prefixIcon: Icon(
                                Icons.phone,
                                color:
                                    phoneFocus.hasFocus ? mainColor : iconColor,
                              ),
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                  color: phoneFocus.hasFocus
                                      ? mainColor
                                      : iconColor),
                              hintText: 'Write your phone number',
                              hintStyle: TextStyle(
                                  color: phoneFocus.hasFocus
                                      ? mainColor
                                      : iconColor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: iconColor),
                                  borderRadius: BorderRadius.circular(2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor),
                                  borderRadius: BorderRadius.circular(2)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: gHeight * 0.015),
                  SizedBox(
                    height: gHeight * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(mainColor)),
                        onPressed: () {
                          if (phoneN.text.length < 10 &&
                              phoneN.text.length > 0) {
                            messenger(context,
                                'You entered a missing number, correct it immediately.');
                          } else if (phoneN.text.length == 0) {
                            messenger(context,
                                "You didn't enter a number, write it immediately.");
                          } else {
                            if (!registerVisibility) {
                              verifyOTP(context);
                            } else {
                              phoneNExists();
                            }
                          }
                        },
                        child: Text(
                          'LOGIN',
                          style: GoogleFonts.poppins(color: Colors.white),
                        )),
                  ),
                  SizedBox(height: gHeight * 0.20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LoginDontHaveAnAccount),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: mainColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(phoneFocus);
    });
  }

  void phoneNExists() async {
    List<Customer> items = await customerListMaker();
    var i = 1;

    for (var element in items) {
      if (element.phone == phoneN.text.replaceAll(' ', '')) {
        loginWithPhone(context);
        break;
      } else {
        if (i == items.length) {
          messenger(context, "Number doesn't exist. Try to register");
        } else {
          i++;
          continue;
        }
      }
    }
  }
}

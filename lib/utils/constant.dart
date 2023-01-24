import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import 'custom_snackbar.dart';

final gWidth = Get.width;
final gHeight = Get.height;
//

final Color mainColor = Color.fromRGBO(223, 152, 234, 1);
final Color iconColor = Color.fromRGBO(230, 193, 72, 1);
final Color textColor = Color.fromARGB(255, 0, 0, 0);
const kPrimaryGradiantColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.fromARGB(255, 98, 161, 229), Color.fromARGB(255, 0, 0, 0)]);
//

const kAnimationDuration = Duration(milliseconds: 200);

void messenger(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: CustomSnackBar(errorMessage: errorMessage),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ));
}

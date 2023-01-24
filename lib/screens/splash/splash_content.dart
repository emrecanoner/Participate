import 'package:flutter/material.dart';
import 'package:participate/utils/constant.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          'Participate',
          style: TextStyle(
              fontSize: 36, color: mainColor, fontWeight: FontWeight.bold),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: gHeight / 3,
          width: gWidth / 1.2,
        )
      ],
    );
  }
}

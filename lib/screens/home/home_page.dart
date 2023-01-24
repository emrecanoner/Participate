import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:participate/screens/home/home_body.dart';
import 'package:participate/screens/home/sign_out/sign_out_page.dart';
import 'package:participate/screens/home/utils.dart';
import 'package:participate/screens/login/otp/utils.dart';
import 'package:participate/screens/splash/splash_screen.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildMyNavBar(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'PARTICIPATE',
          style: styleOnBoardTitle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              AnimatedSignOut(context);
              AuthService().signOut();
            },
            icon: Icon(Icons.output_outlined),
            color: mainColor,
          )
        ],
      ),
      body: pageList[pageIndex],
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: gWidth / 15, right: gWidth / 15),
      height: gHeight / 12,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:participate/screens/welcome/welcome_screen.dart';
import 'package:participate/utils/constant.dart';
import 'package:participate/utils/images.dart';
import 'package:participate/utils/texts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void dispose() {
    super.dispose();
  }

  final controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: gHeight / 50, horizontal: gWidth / 30),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(OnBoardImage1),
                      height: gHeight * 0.4,
                    ),
                    Column(
                      children: [
                        Text(
                          OnBoardTitle1,
                          style: styleOnBoardTitle,
                          textAlign: TextAlign.center,
                        ),
                        Text(OnBoardSubTitle1,
                            style: styleOnBoardSubTitle,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: gHeight / 50, horizontal: gWidth / 30),
                color: mainColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(OnBoardImage2),
                      height: gHeight * 0.4,
                    ),
                    Column(
                      children: [
                        Text(
                          OnBoardTitle2,
                          style: styleOnBoardTitle,
                          textAlign: TextAlign.center,
                        ),
                        Text(OnBoardSubTitle2,
                            style: styleOnBoardSubTitle,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: gHeight / 50, horizontal: gWidth / 30),
                color: iconColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(OnBoardImage3),
                      height: gHeight * 0.4,
                    ),
                    Column(
                      children: [
                        Text(
                          OnBoardTitle3,
                          style: styleOnBoardTitle,
                          textAlign: TextAlign.center,
                        ),
                        Text(OnBoardSubTitle3,
                            style: styleOnBoardSubTitle,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            ],
            waveType: WaveType.circularReveal,
            liquidController: controller,
            onPageChangeCallback: OnPageChangeCallback,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            positionSlideIcon: 0.8,
            enableSideReveal: true,
          ),
          Positioned(
            bottom: 60.0,
            child: OutlinedButton(
              onPressed: () {
                int nextPage = controller.currentPage + 1;
                controller.animateToPage(page: nextPage);
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color(0xff272727), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomeScreen(),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(color: Color(0xff757575)),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: 3,
              effect: const WormEffect(
                dotWidth: 25,
                activeDotColor: Color(0xff272727),
                dotHeight: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void OnPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}

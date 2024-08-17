import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //get start variable
  RxBool isTab = RxBool(false);

  @override
  void onInit() {
    // Future.delayed(const Duration(seconds: 2), () {
    //   Get.to(const OnboardingPage(),
    //       transition: Transition.fadeIn, duration: 500.ms);
    // });
    super.onInit();
  }

  ///onboarding
  final onBoardingPageController = PageController();
  RxInt currentIndexOnBoarding = RxInt(0);
}
import 'dart:developer';

import 'package:alsat/app/modules/app_home/view/app_home_view.dart';
import 'package:alsat/app/modules/authentication/view/login_view.dart';
import 'package:alsat/app/modules/parent/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../data/local/my_shared_pref.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // MySharedPref.clear();
        bool onboardingCompleted = MySharedPref.isOnboardingComplete();
        Logger().d(onboardingCompleted); // Check if onboarding is completed
        bool isLoggedIn =
            MySharedPref.isLoggedIn(); // Check if user is logged in
        String? token = MySharedPref
            .getAuthToken(); // Get the token from shared preferences
        log("token: $token");
        // Navigate based on onboarding and login status
        if (!onboardingCompleted) {
          // If onboarding is not complete, navigate to OnboardingPage
          Get.offAll(() => const OnboardingPage());
        } else if (!isLoggedIn) {
          // If user is not logged in, navigate to FilterView (or login view)
          Get.offAll(() => const LoginView());
        } else {
          // If onboarding is completed and user is logged in, navigate to HomePage
          Get.offAll(() => const AppHomeView());
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/appicon.png',
          height: 200,
          width: 200,
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .shimmer(duration: 1500.ms),
      ),
    );
  }
}

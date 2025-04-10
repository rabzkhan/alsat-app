import 'dart:developer';

import 'package:alsat/app/modules/app_home/view/app_home_view.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
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
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/appicon.png',
          height: 150,
          width: 150,
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .shimmer(duration: 1500.ms),
      ),
    );
  }
}

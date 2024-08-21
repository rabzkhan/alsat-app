import 'package:alsat/app/modules/authentication/view/login_view.dart';
import 'package:alsat/app/modules/authentication/view/signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../common/const/image_path.dart';
import '../../app_home/view/app_home_view.dart';
import '../../authentication/controller/auth_controller.dart';
import '../controller/splash_controller.dart';
import '../data/onbording_data.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.find();
    final AuthController authController = Get.find();
    return Scaffold(
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          logo,
          width: 100.w,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.sp),
            child: TextButton.icon(
              onPressed: () {
                splashController.currentIndexOnBoarding.value = 2;
                splashController.onBoardingPageController.animateToPage(2,
                    duration: 400.ms, curve: Curves.linearToEaseOut);
              },
              icon: Text(
                'Skip',
                style: Get.theme.textTheme.titleLarge!.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              label: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 14.r,
                color: Get.theme.textTheme.titleLarge!.color,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: splashController.onBoardingPageController,
            onPageChanged: (value) {
              splashController.currentIndexOnBoarding.value = value;
            },
            children: onBoardingData
                .map((e) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() {
                          return Expanded(
                            flex: 3,
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 100.w,
                                ),
                                height: Get.height * .16,
                                child: Image.asset(
                                  onBoardingData[splashController
                                          .currentIndexOnBoarding.value]
                                      .imageUrl,
                                  key: ValueKey<int>(splashController
                                      .currentIndexOnBoarding.value),

                                  height: Get.height * .16,
                                  fit: BoxFit.fill,
                                  // fit: BoxFit.contain,
                                ).animate().fadeIn(delay: 200.ms),
                              ),
                            ),
                          );
                        }),
                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 18.w),
                                  child: TextAnimator(
                                    incomingEffect: WidgetTransitionEffects
                                        .incomingScaleDown(
                                      duration:
                                          const Duration(milliseconds: 1000),
                                    ),
                                    e.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                                8.verticalSpace,
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.w),
                                  child: TextAnimator(
                                    incomingEffect: WidgetTransitionEffects
                                        .incomingSlideInFromRight(
                                            delay: const Duration(
                                                milliseconds: 0)),
                                    // overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    e.detail,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Get.theme.brightness ==
                                                  Brightness.dark
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                  ),
                                ).animate().fadeIn(
                                      delay: 300.ms,
                                    ),
                                const Spacer(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 40.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        return splashController
                                                    .currentIndexOnBoarding
                                                    .value <
                                                2
                                            ? Expanded(
                                                child: CupertinoButton.filled(
                                                  child: Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    int value = splashController
                                                        .currentIndexOnBoarding
                                                        .value;

                                                    value++;
                                                    splashController
                                                        .currentIndexOnBoarding
                                                        .value = value;
                                                    splashController
                                                        .onBoardingPageController
                                                        .animateToPage(
                                                      value,
                                                      duration: 400.ms,
                                                      curve: Curves
                                                          .linearToEaseOut,
                                                    );
                                                  },
                                                ),
                                              )
                                            : Expanded(
                                                child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      // AppHomeView
                                                      Get.to(const LoginView(),
                                                          transition: Transition
                                                              .fadeIn);
                                                    },
                                                    child: Text(
                                                      'Login',
                                                      style: Get.theme.textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                    ),
                                                    color:
                                                        Get.theme.dividerColor,
                                                    width: 1,
                                                    height: 15.h,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.to(const SignUpView(),
                                                          transition: Transition
                                                              .fadeIn);
                                                    },
                                                    child: Text(
                                                      'Sign Up',
                                                      style: Get.theme.textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                      }),
                                    ],
                                  ),
                                ).animate().fadeIn(
                                      duration: 1000.ms,
                                    ),
                                const Spacer(),
                              ],
                            ))
                      ],
                    ))
                .toList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            height: 120.h,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: splashController.onBoardingPageController,
                  count: onBoardingData.length,
                  axisDirection: Axis.horizontal,
                  effect: ExpandingDotsEffect(
                    dotHeight: 3.h,
                    radius: 3.r,
                    activeDotColor: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

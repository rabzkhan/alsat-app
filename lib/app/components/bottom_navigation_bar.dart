import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: Get.width,
      height: 70.h,
      borderRadius: 2,
      blur: 30,
      alignment: Alignment.bottomCenter,
      border: 0,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.5),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    chatIcon,
                    width: 50.w,
                    height: 25.h,
                  ),
                  5.verticalSpace,
                  Text(
                    'Chat',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    categoryIcon,
                    width: 50.w,
                    height: 25.h,
                  ),
                  5.verticalSpace,
                  Text(
                    'Category',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    addPost,
                    width: 40.w,
                    height: 25.h,
                    fit: BoxFit.cover,
                  ),
                  5.verticalSpace,
                  Text(
                    'Post Add',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    homeIcon,
                    width: 50.w,
                    height: 25.h,
                  ),
                  5.verticalSpace,
                  Text(
                    'Home',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    profileIcon,
                    width: 50.w,
                    height: 25.h,
                  ),
                  5.verticalSpace,
                  Text(
                    'Profile',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

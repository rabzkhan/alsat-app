import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/promotions/view/my_promotions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../config/theme/app_text_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: Get.width * .6,
      height: double.infinity,
      blur: 20, // Blur effect
      border: 0, // No border
      borderRadius: 30, // Optional: Adjust the rounded corners
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.1), Colors.black.withOpacity(0.1)],
        stops: [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.3), Colors.black.withOpacity(0.3)],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 20.h,
        ),
        child: Column(
          children: [
            50.verticalSpace,
            const ListTile(
              leading: CircleAvatar(),
              title: Text('Alexander Davis'),
              subtitle: Text('+12548514'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          const MyPromotionsView(),
                          transition: Transition.fadeIn,
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            crownIcon,
                            width: 25.w,
                            color: Get.theme.textTheme.bodyLarge!.color!,
                          ),
                          10.horizontalSpace,
                          Text(
                            'My Promotions',
                            style: regular.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Image.asset(
                          chatIcon,
                          width: 25.w,
                          color: Get.theme.textTheme.bodyLarge!.color!,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Chat To Aadmin',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Image.asset(
                          sportIcon,
                          width: 25.w,
                          color: Get.theme.textTheme.bodyLarge!.color!,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Sport',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Image.asset(
                          newsIcon,
                          width: 25.w,
                          color: Get.theme.textTheme.bodyLarge!.color!,
                        ),
                        10.horizontalSpace,
                        Text(
                          'News',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Image.asset(
                          drawerSetting,
                          width: 25.w,
                          color: Get.theme.textTheme.bodyLarge!.color!,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Setting',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    120.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideX(
          duration: 600.ms,
          begin: -2,
          curve: Curves.fastOutSlowIn,
        );
  }
}

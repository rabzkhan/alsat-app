import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            _bottomItem(
              icon: homeIcon,
              name: 'Home',
            ),
            _bottomItem(
              icon: chatIcon,
              name: 'Chat',
            ),
            _bottomItem(
              icon: categoryIcon,
              name: 'Category',
            ),
            _bottomItem(
              icon: addPost,
              name: 'Post Add',
            ),
            _bottomItem(
              icon: profileIcon,
              name: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Expanded _bottomItem({required String name, required String icon}) {
    final homeController = Get.put(HomeController());
    return Expanded(
      child: Obx(() {
        return InkWell(
          onTap: () {
            homeController.homeBottomIndex.value = name;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width:
                    homeController.homeBottomIndex.value == name ? 52.w : 47.w,
                height:
                    homeController.homeBottomIndex.value == name ? 27.h : 22.h,
                child: Image.asset(
                  icon,
                  color: homeController.homeBottomIndex.value == name
                      ? Get.theme.primaryColor
                      : Get.theme.disabledColor,
                ),
              ),
              5.verticalSpace,
              Text(
                name,
                style: regular.copyWith(
                  fontSize: 11.sp,
                  color: homeController.homeBottomIndex.value == name
                      ? Get.theme.primaryColor
                      : Get.theme.disabledColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

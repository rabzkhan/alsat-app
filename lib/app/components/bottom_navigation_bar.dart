// ignore_for_file: deprecated_member_use

import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/product/view/post_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../config/theme/app_text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(Get.context!)!;
    final homeController = Get.put(HomeController());
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
            ...List.generate(homeController.bottomBarItems(local).length,
                (index) {
              return _bottomItem(
                icon: homeController.bottomBarItems(local)[index]['icon'],
                name: homeController.bottomBarItems(local)[index]['name'],
                index: index,
              );
            }),
          ],
        ),
      ),
    );
  }

  Expanded _bottomItem(
      {required String name, required String icon, required int index}) {
    final homeController = Get.put(HomeController());
    return Expanded(
      child: Obx(() {
        return InkWell(
          onTap: () {
            if (index == 2) {
              Get.to(const PostProductView(), transition: Transition.fadeIn);
            } else {
              homeController.homePageController.animateToPage(
                index,
                duration: 200.ms,
                curve: Curves.fastLinearToSlowEaseIn,
              );
              homeController.homeBottomIndex.value = index;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width:
                    homeController.homeBottomIndex.value == index ? 52.w : 47.w,
                height:
                    homeController.homeBottomIndex.value == index ? 27.h : 22.h,
                child: Image.asset(
                  icon,
                  color: homeController.homeBottomIndex.value == index
                      ? Get.theme.primaryColor
                      : Get.theme.disabledColor,
                ),
              ),
              5.verticalSpace,
              Text(
                maxLines: 1,
                textAlign: TextAlign.center,
                name,
                style: regular.copyWith(
                  fontSize: 11.sp,
                  color: homeController.homeBottomIndex.value == index
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

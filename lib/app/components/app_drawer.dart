import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
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
    HomeController homeController = Get.find<HomeController>();
    return Obx(() {
      return (homeController.isShowDrawer.value)
          ? GlassmorphicContainer(
              width: Get.width * .6,
              height: double.infinity,
              borderRadius: 2,
              blur: 30,
              alignment: Alignment.bottomCenter,
              border: 0,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFffffff).withOpacity(0.1),
                    const Color(0xFFFFFFFF).withOpacity(0.8),
                  ],
                  stops: const [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFffffff).withOpacity(0.5),
                  Color((0xFFFFFFFF)).withOpacity(0.8),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 20.h,
                ),
                child: Column(
                  children: [
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
                            Row(
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
                            10.verticalSpace,
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
              )
          : const Center();
    });
  }
}

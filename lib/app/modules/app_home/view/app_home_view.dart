import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/app_home/component/add_post_content.dart';
import 'package:alsat/app/modules/app_home/component/category_content.dart';
import 'package:alsat/app/modules/app_home/component/chat_content.dart';
import 'package:alsat/app/modules/app_home/component/home_content.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../components/product_tile.dart';
import '../component/profile_content.dart';
import '../controller/home_controller.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({super.key});

  @override
  State<AppHomeView> createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView> {
  HomeController homeController = Get.find<HomeController>();
  FilterController filterController = Get.find<FilterController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.secondaryHeaderColor,
      body: SafeArea(
        child: Column(
          children: [
            //custom appbar
            const CustomAppbar(),
            //body
            Expanded(
              child: Stack(
                children: [
                  NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        if (homeController.isShowDrawer.value) {
                          homeController.isShowDrawer.value = false;
                        }
                      }
                      return true;
                    },
                    child: Container(
                      color: Get.theme.secondaryHeaderColor,
                      child: Column(
                        children: [
                          //HOME TAB
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 20.h,
                            ).copyWith(
                              top: 10.h,
                            ),
                            height: 45.h,
                            width: Get.width * 0.7,
                            color: Get.theme.appBarTheme.backgroundColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 45.h,
                                    child: PhysicalModel(
                                      shadowColor: Get.theme.primaryColor,
                                      color: Get
                                          .theme.appBarTheme.backgroundColor!,
                                      elevation: 2,
                                      shape: BoxShape.circle,
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Get
                                            .theme.appBarTheme.backgroundColor!,
                                        height: 45.h,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "Product",
                                          style: regular.copyWith(
                                            fontSize: 17.sp,
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30.h,
                                  color:
                                      Get.theme.disabledColor.withOpacity(.1),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 45.h,
                                    child: PhysicalModel(
                                      shadowColor: Get.theme.primaryColor,
                                      color: Get
                                          .theme.appBarTheme.backgroundColor!,
                                      elevation: 2,
                                      shape: BoxShape.circle,
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Get
                                            .theme.appBarTheme.backgroundColor!,
                                        height: 45.h,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 14.r,
                                              backgroundColor: Get
                                                  .theme.secondaryHeaderColor
                                                  .withOpacity(.5),
                                              child: Image.asset(
                                                crownIcon,
                                                width: 18.w,
                                                height: 20.h,
                                                color: Get.theme.disabledColor
                                                    .withOpacity(.1),
                                              ),
                                            ),
                                            5.horizontalSpace,
                                            Text(
                                              textAlign: TextAlign.center,
                                              "Premium",
                                              style: regular.copyWith(
                                                fontSize: 17.sp,
                                                // color: Get.theme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: PageView(
                              children: const [
                                HomeContent(),
                                ChatContent(),
                                CategoryContent(),
                                AddPostContent(),
                                ProfileContent(),
                              ],
                            ),
                          ),
                          const AppBottomNavigationBar(),
                        ],
                      ),
                    ),
                  ),
                  //app drawer
                  const AppDrawer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

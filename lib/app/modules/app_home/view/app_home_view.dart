import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/app_drawer.dart';
import 'package:alsat/app/components/bottom_navigation_bar.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/product_tile.dart';
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
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                //HOME SLIDER
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.h,
                                  ).copyWith(
                                    top: 6.h,
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 160.h, aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.3,
                                      // onPageChanged: callbackFunction,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    items: [
                                      Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image:
                                                      AssetImage(appSliderBg)),
                                              color: Get.theme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: _demoData(),
                                          ),
                                          Positioned(
                                            right: -10,
                                            top: 0,
                                            bottom: 0,
                                            child: Container(
                                              width: 30.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Get.theme.appBarTheme
                                                    .backgroundColor!
                                                    .withOpacity(.7),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: Get.theme.appBarTheme
                                                    .backgroundColor!
                                                    .withOpacity(.8),
                                                size: 20.r,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(appSliderBg)),
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: _demoData(),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(appSliderBg)),
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: _demoData(),
                                      ),
                                    ],
                                  ),
                                ),
                                // category list
                                SizedBox(
                                  width: double.infinity,
                                  height: 90.h,
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      20.horizontalSpace,
                                      ...List.generate(
                                        10,
                                        (index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 5.h,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 55.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  child: Image.asset(
                                                    carImage,
                                                  ),
                                                ),
                                                Text(
                                                  "Nissan GT - R",
                                                  style: regular.copyWith(
                                                    fontSize: 8.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // home prosuct car list
                                10.verticalSpace,
                                const ProductTile(),
                                const ProductTile(),
                                const ProductTile(),
                                const ProductTile(),
                                const ProductTile(),
                                const ProductTile(),
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

  Column _demoData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        4.verticalSpace,
        Text(
          textAlign: TextAlign.left,
          "The Best Platform for Car Rental",
          style: regular.copyWith(
            fontSize: 18.sp,
            color: Get.theme.appBarTheme.backgroundColor,
          ),
        ),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.only(right: 50.w),
          child: Text(
            textAlign: TextAlign.left,
            "Ease of doing a car rental safely and reliably. Of course at a low price.",
            style: regular.copyWith(
              fontSize: 14.sp,
              color: Get.theme.appBarTheme.backgroundColor,
            ),
          ),
        ),
        10.verticalSpace,
        Expanded(
          child: Row(
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3563E9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 13.h,
                  ),
                  child: Text(
                    "Rental Car",
                    style: regular.copyWith(
                      fontSize: 14.sp,
                      color: Get.theme.appBarTheme.backgroundColor,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              Expanded(
                child: Image.asset(carImage),
              ),
            ],
          ),
        )
      ],
    );
  }
}

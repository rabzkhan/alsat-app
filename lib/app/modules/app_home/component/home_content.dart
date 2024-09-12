import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/category_tile.dart';
import '../../../components/home_segmented.dart';
import '../../../components/product_list_tile.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeSegmented(),
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
                    autoPlayInterval: const Duration(seconds: 3),
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
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(appSliderBg)),
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(20.r),
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
                              color: Get.theme.appBarTheme.backgroundColor!
                                  .withOpacity(.7),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Get.theme.appBarTheme.backgroundColor!
                                  .withOpacity(.8),
                              size: 20.r,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(appSliderBg)),
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: _demoData(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(appSliderBg)),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.r),
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
                        return const CategoryTile();
                      },
                    ),
                  ],
                ),
              ),
              // home prosuct car list
              10.verticalSpace,
              const ProductListTile(),
              const ProductListTile(),
              const ProductListTile(),
              const ProductListTile(),
              const ProductListTile(),
              const ProductListTile(),
            ],
          ),
        ),
      ],
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

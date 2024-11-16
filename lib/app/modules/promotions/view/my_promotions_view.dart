import 'package:alsat/app/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:wave/wave.dart';/

import '../../../../config/theme/app_text_theme.dart';

class MyPromotionsView extends StatefulWidget {
  const MyPromotionsView({super.key});

  @override
  State<MyPromotionsView> createState() => _MyPromotionsViewState();
}

class _MyPromotionsViewState extends State<MyPromotionsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            const CustomAppBar(
              isShowSearch: false,
              isShowFilter: false,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                unselectedLabelColor: Colors.black,
                tabs: ['Urgent', 'Advertisement', 'Expired']
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList(),
              ),
            ),
            Expanded(
                child: ListView(
              children: const [
                PromotionTile(),
              ],
            ))
          ],
        )),
      ),
    );
  }
}

class PromotionTile extends StatelessWidget {
  const PromotionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 14.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        color: Get.theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 10.w,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    'assets/images/car_demo.png',
                    height: 60.h,
                    width: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              4.horizontalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: 'Hyundai santa fe ',
                          style: regular.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                        TextSpan(
                          text: '2014',
                          style: medium.copyWith(
                            fontSize: 15.sp,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ])),
                      Text(
                        'Lorem ipsum is placeholder text  ',
                        style: regular.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "\$96.00/",
                          style: bold.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                        TextSpan(
                          text: ' day',
                          style: regular.copyWith(
                            fontSize: 11.sp,
                            color: Get.theme.disabledColor,
                          ),
                        ),
                        TextSpan(
                          text: ' | ',
                          style: regular.copyWith(
                            fontSize: 12.sp,
                            color: Get.theme.disabledColor,
                          ),
                        ),
                        TextSpan(
                          text: 'United States / Los Angeles',
                          style: regular.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ])),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 15.w,
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plan 1",
                      style:
                          bold.copyWith(fontSize: 16.sp, color: Colors.black),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "\$96.00/",
                        style: bold.copyWith(
                          fontSize: 15.sp,
                        ),
                      ),
                      TextSpan(
                        text: ' day',
                        style: regular.copyWith(
                          fontSize: 11.sp,
                          color: Get.theme.disabledColor,
                        ),
                      ),
                    ]))
                  ],
                ),
                const Spacer(),
                // WaveWidget(
                //   isLoop: false,
                //   config: CustomConfig(
                //     colors: [
                //       Colors.red.shade100,
                //       Colors.green.shade100,
                //     ],
                //     durations: [300, 500],
                //     heightPercentages: [
                //       0.2,
                //       0.4,
                //     ],
                //   ),
                //   backgroundColor: Colors.transparent,
                //   size: Size(120.w, 30.h),
                //   waveAmplitude: 0,
                // ),
                const Spacer(),
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(.1),
                    border: Border.all(
                      color: Colors.green.withOpacity(.5),
                    ),
                  ),
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.green.withOpacity(.9),
                    size: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          5.verticalSpace,
        ],
      ),
    );
  }
}

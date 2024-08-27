import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key});

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
      height: 90.h,
      decoration: BoxDecoration(
        color: Get.theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
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
                    height: 90.h,
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
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 15.r,
                                color: Get.theme.disabledColor,
                              ),
                              Text(
                                'Credit',
                                style: regular.copyWith(
                                  color: Get.theme.disabledColor,
                                  fontSize: 10.sp,
                                ),
                              )
                            ],
                          ),
                          5.horizontalSpace,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 15.r,
                                color: Get.theme.disabledColor,
                              ),
                              Text(
                                'exchange',
                                style: regular.copyWith(
                                  color: Get.theme.disabledColor,
                                  fontSize: 10.sp,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            right: 10.w,
            top: 4.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Get.theme.disabledColor.withOpacity(.06),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20.r,
              ),
            ),
          )
        ],
      ),
    );
  }
}

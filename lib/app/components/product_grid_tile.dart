import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/product/view/product_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(const ProductDetailsView(), transition: Transition.fadeIn);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: Get.theme.appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      carImage,
                      height: 90.h,
                      width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                2.verticalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
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
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

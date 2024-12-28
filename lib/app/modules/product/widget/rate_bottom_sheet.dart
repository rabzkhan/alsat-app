import 'dart:ui';

import 'package:alsat/app/components/network_image_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../controller/product_details_controller.dart';

showRateBottomSheet(
    BuildContext context, ProductDetailsController productDetailsController) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.r),
        topRight: Radius.circular(15.r),
      ),
    ),
    isDismissible: true,
    context: context,
    builder: (context) {
      return SizedBox(
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: Get.height * .4,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Text(
                    '${productDetailsController.postUserModel.value?.userName}',
                    style: regular.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    textAlign: TextAlign.center,
                    'Your feedback will help to improve\n our experience.',
                    style: regular.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  8.verticalSpace,
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_rate_rounded,
                      color: Colors.black54,
                      size: 22.r,
                    ),
                    onRatingUpdate: (rating) {
                      productDetailsController.userRate.value = rating;
                    },
                  ),
                  Expanded(
                      child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: ElevatedButton(
                              onPressed: () {
                                productDetailsController.rateUser();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Ok',
                                style: regular.copyWith(
                                  color: Get.theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Positioned(
              top: -50.h,
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.white,
                child: NetworkImagePreview(
                  radius: 48.r,
                  url: productDetailsController.postUserModel.value?.picture ??
                      '',
                  height: 96.h,
                  width: 96.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Obx(() {
              return productDetailsController.isRateUserLoading.value
                  ? Container(
                      height: Get.height * .4,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 26.r,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: Get.height * .4,
                      width: Get.width,
                    );
            })
          ],
        ),
      );
    },
  );
}

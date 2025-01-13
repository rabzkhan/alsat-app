import 'dart:developer';

import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_theme.dart';
import '../../../filter/models/location_model.dart';

class ProfileSingleLocationSelection extends StatelessWidget {
  const ProfileSingleLocationSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Select Location',
              style: bold.copyWith(fontSize: 16.sp),
            ),
            trailing: CupertinoButton(
              onPressed: () {
                Get.back();
              },
              padding: EdgeInsets.zero,
              child: Text(
                'Select',
                style: regular.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            )),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                return Column(
                  children: [
                    ...List.generate(
                      provinces.length,
                      (provinceIndex) {
                        final province = provinces[provinceIndex];
                        return ExpansionTile(
                          title: InkWell(
                            onTap: () {
                              // Toggle province selection
                              authController.selectedProvince.value =
                                  province.name;
                              authController.addressController.text =
                                  province.name;
                              authController.selectedCity.value = '';
                            },
                            child: Row(
                              children: [
                                Text(
                                  province.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: AppColors.liteGray,
                                  child: Icon(
                                    authController.selectedProvince.value ==
                                            province.name
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: AppColors.primary,
                                    size: 20.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          expandedAlignment: Alignment.centerLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: EdgeInsets.symmetric(
                              horizontal: Get.width * .06, vertical: 10.h),
                          children: [
                            ...province.cities.map(
                              (city) {
                                return InkWell(
                                  onTap: () {
                                    authController.selectedProvince.value =
                                        province.name;
                                    authController.selectedCity.value = city;
                                    authController.addressController.text =
                                        '$city, ${province.name}';

                                    log("${'$city, ${province.name}'}");
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    child: Row(
                                      children: [
                                        Text(
                                          city,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        CircleAvatar(
                                          radius: 8.r,
                                          backgroundColor: AppColors.liteGray,
                                          child: Icon(
                                            authController.selectedCity.value ==
                                                    city
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: AppColors.primary,
                                            size: 14.r,
                                          ),
                                        ),
                                        20.horizontalSpace,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

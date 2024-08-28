import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';

class HomeSegmented extends StatelessWidget {
  const HomeSegmented({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                color: Get.theme.appBarTheme.backgroundColor!,
                elevation: 2,
                shape: BoxShape.circle,
                child: Container(
                  alignment: Alignment.center,
                  color: Get.theme.appBarTheme.backgroundColor!,
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
            color: Get.theme.disabledColor.withOpacity(.1),
          ),
          Expanded(
            child: SizedBox(
              height: 45.h,
              child: PhysicalModel(
                shadowColor: Get.theme.primaryColor,
                color: Get.theme.appBarTheme.backgroundColor!,
                elevation: 2,
                shape: BoxShape.circle,
                child: Container(
                  alignment: Alignment.center,
                  color: Get.theme.appBarTheme.backgroundColor!,
                  height: 45.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 14.r,
                        backgroundColor:
                            Get.theme.secondaryHeaderColor.withOpacity(.5),
                        child: Image.asset(
                          crownIcon,
                          width: 18.w,
                          height: 20.h,
                          color: Get.theme.disabledColor.withOpacity(.1),
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
    );
  }
}

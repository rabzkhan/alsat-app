import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/formate_datetime.dart';
import '../../../components/network_image_preview.dart';
import '../../../components/scrolling_text.dart';
import '../models/notification_res.dart';

notificationDialog({NotificationData? data}) {
  Get.dialog(
    Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).r,
            color: Colors.white,
          ),
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScrollingTextWidget(
                  child: Text(
                    data?.title ?? '',
                    style: Theme.of(Get.context!).textTheme.bodyLarge,
                  ),
                ),
                10.verticalSpace,
                NetworkImagePreview(
                  fit: BoxFit.cover,
                  radius: 6.r,
                  url: data?.picture ?? '',
                  height: 200.h,
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatDateTime(data?.updatedAt ?? ''),
                      style: Theme.of(Get.context!).textTheme.labelMedium!.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Text(
                  data?.body ?? '',
                  style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

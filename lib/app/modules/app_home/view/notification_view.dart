import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/formate_datetime.dart';
import '../../../components/network_image_preview.dart';
import '../../../components/scrolling_text.dart';

class NotificationView extends GetView<HomeController> {
  const NotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Notifications', style: medium),
      ),
      body: Obx(
        () => Skeletonizer(
          // effect: ShimmerEffect(
          //   baseColor: Get.theme.disabledColor.withOpacity(.2),
          //   highlightColor: Colors.white,
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          // ),
          enabled: controller.isNotificationLoading.value,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(bottom: 50.h),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                    NetworkImagePreview(
                      fit: BoxFit.cover,
                      radius: 6.r,
                      url: controller.notifications[index].picture ?? '',
                      height: 80.h,
                      width: 100.w,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollingTextWidget(
                            child: Text(
                              controller.notifications[index].title ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            controller.notifications[index].body ?? '',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey.shade700),
                          ),
                          2.verticalSpace,
                          Text(
                            formatDateTime(controller.notifications[index].updatedAt ?? ''),
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

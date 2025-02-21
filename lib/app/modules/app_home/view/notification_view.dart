import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(bottom: 50.h),
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber[900],
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(12).r,
                  //   child: SvgPicture.asset(
                  //     "assets/vectors/pay-history.svg",
                  //     height: 18.h,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Appointment Confirmed", style: Theme.of(context).textTheme.bodyMedium),
                          Text(
                            "9:30 am",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                      6.verticalSpace,
                      Text(
                        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in print...",
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  final double? bottomHeight;
  final String? title;
  final bool isShowIcon;
  const NoDataWidget(
      {super.key, this.bottomHeight, this.title, this.isShowIcon = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.7,
        child: Stack(
          children: [
            if (isShowIcon)
              Positioned(
                top: 0,
                bottom: 150.h,
                left: -2,
                child: Image.asset(
                  'assets/images/leaf.png',
                  height: 100,
                  width: Get.width * .18,
                  color: context.theme.primaryColor,
                ),
              ),
            if (isShowIcon)
              Positioned(
                top: 0,
                bottom: 150.h,
                right: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: Image.asset(
                    'assets/images/leaf.png',
                    height: 100,
                    width: Get.width * .18,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isShowIcon)
                  Image.asset(
                    'assets/images/nodata.png',
                    height: 150.h,
                    color: context.theme.primaryColor,
                  ),
                2.verticalSpace,
                Text(
                  title ?? 'No Data Available Yet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: context.theme.primaryColor,
                  ),
                ),
                2.verticalSpace,
                Text(
                  "We can't find what you're looking for.",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w300,
                    color: context.theme.primaryColor,
                  ),
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        backgroundColor:
                            context.theme.primaryColor.withOpacity(.3),
                        color: context.theme.primaryColor,
                        minHeight: 1.w,
                        value: 0,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white30,
                        color: context.theme.primaryColor,
                        minHeight: 1.w,
                        value: 1,
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        backgroundColor:
                            context.theme.primaryColor.withOpacity(.3),
                        color: Colors.white,
                        minHeight: 1.w,
                        value: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: bottomHeight ?? 50.h),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 500.ms,
          curve: Curves.easeInOut,
        );
  }
}

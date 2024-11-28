import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../components/scrolling_text.dart';
import '../../../global/app_decoration.dart';

class FilterOptionWidget extends StatelessWidget {
  const FilterOptionWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.titleSub,
  });
  final String title;
  final String? titleSub;
  final String subTitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: borderedContainer,
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 12.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: bold.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        titleSub ?? "",
                        style: regular.copyWith(
                          fontSize: 10.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  ScrollingTextWidget(
                    child: Text(
                      subTitle,
                      style: medium.copyWith(
                        fontSize: 10.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 30.h,
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}

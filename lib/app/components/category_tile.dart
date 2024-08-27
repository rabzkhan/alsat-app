import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';

class CategoryTile extends StatelessWidget {
  final bool isAddedPadding;
  const CategoryTile({
    super.key,
    this.isAddedPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: isAddedPadding
          ? EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 5.h,
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Image.asset(
              carImage,
            ),
          ),
          Text(
            "Nissan GT - R",
            style: regular.copyWith(
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }
}

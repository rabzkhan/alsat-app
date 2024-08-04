import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final borderedContainer = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(8.r),
  ),
  border: Border.all(
    color: AppColors.liteGray,
    width: 1.5.w,
  ),
);

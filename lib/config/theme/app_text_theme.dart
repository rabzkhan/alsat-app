import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final regular = TextStyle(
  fontWeight: FontWeight.w400,
  color: Colors.black,
  fontSize: 14.sp,
);

final medium = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.black,
  fontSize: 14.sp,
);

final semiBold = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 14.sp,
);

final bold = TextStyle(
  fontWeight: FontWeight.w700,
  color: Colors.black,
  fontSize: 14.sp,
);

var outlineBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: Get.theme.shadowColor.withOpacity(.2),
  ),
);
var outlineBorderPrimary = OutlineInputBorder(
  borderSide: BorderSide(
    color: Get.theme.primaryColor.withOpacity(.5),
  ),
);

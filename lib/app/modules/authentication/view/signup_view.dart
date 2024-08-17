import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/const/image_path.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Image.asset(
          logo,
          width: 100.w,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150.h),
          child: Padding(
            padding:  EdgeInsets.only(bottom: 15.h),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: Get.theme.disabledColor.withOpacity(.05),
              child: Image.asset(
                signUpLogo,
                height: 100.h,
              ),
            ),
          ),
        ),
      ),
      body:  ListView(
        children: [

        ],
      ),
    );
  }
}

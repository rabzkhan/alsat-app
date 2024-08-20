import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../controller/auth_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
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
            padding: EdgeInsets.only(bottom: 15.h),
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
      body: FormBuilder(
        key: authController.signUpFormKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 30.h,
          ),
          children: [
            20.verticalSpace,
            FormBuilderTextField(
              name: 'phone',
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Get.theme.shadowColor.withOpacity(.6),
                ),
                border: outlineBorder,
                enabledBorder: outlineBorder,
                errorBorder: outlineBorder,
                focusedBorder: outlineBorder,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            20.verticalSpace,
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Get.theme.shadowColor.withOpacity(.6),
                ),
                labelText: 'Password',
                border: outlineBorder,
                enabledBorder: outlineBorder,
                errorBorder: outlineBorder,
                focusedBorder: outlineBorder,
              ),
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            20.verticalSpace,
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Get.theme.shadowColor.withOpacity(.6),
                ),
                labelText: 'Confirm Password',
                border: outlineBorder,
                enabledBorder: outlineBorder,
                errorBorder: outlineBorder,
                focusedBorder: outlineBorder,
              ),
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

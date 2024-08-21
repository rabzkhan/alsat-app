import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../app_home/view/app_home_view.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
            color: Get.theme.appBarTheme.backgroundColor!.withOpacity(.7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.r),
              topRight: Radius.circular(60.r),
            )),
        child: FormBuilder(
          key: authController.loginFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
              vertical: 30.h,
            ),
            children: [
              30.verticalSpace,
              FormBuilderTextField(
                name: 'phone',
                decoration: InputDecoration(
                  isDense: true,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  isDense: true,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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

              50.verticalSpace,

              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      onPressed: () {

                        Get.to(const AppHomeView(),
                            transition: Transition
                                .fadeIn);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  )
                ],
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New User?',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  6.horizontalSpace,
                  InkWell(
                    onDoubleTap: () {

                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

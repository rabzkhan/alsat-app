import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../app_home/view/app_home_view.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
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
              backgroundColor: Get.theme.disabledColor.withValues(alpha: .05),
              child: InkWell(
                onTap: () async {
                  await MySharedPref.clear();
                },
                child: Image.asset(
                  signUpLogo,
                  height: 100.h,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAll(const AppHomeView(), transition: Transition.fadeIn);
            },
            icon: const Icon(
              Icons.skip_next_outlined,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Get.theme.appBarTheme.backgroundColor!.withValues(alpha: .7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.r),
              topRight: Radius.circular(60.r),
            )),
        child: FormBuilder(
          key: controller.loginFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
              vertical: 30.h,
            ),
            children: [
              30.verticalSpace,
              FormBuilderTextField(
                name: 'phone',
                controller: controller.phoneNumberController.value,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(controller.countryCode.value),
                  ),
                  isDense: true,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: localLanguage.phone_number,
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
                ]),
              ),
              Obx(() {
                if (controller.hasStartedOtpProcess.value) {
                  final minutes = (controller.countdown.value ~/ 60).toString().padLeft(2, '0');
                  final seconds = (controller.countdown.value % 60).toString().padLeft(2, '0');
                  return Column(
                    children: [
                      20.verticalSpace,
                      Center(
                        child: Text(
                          controller.canResendOtp.value
                              ? ""
                              : "${localLanguage.resend_otp_in} $minutes:$seconds ${localLanguage.min}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      // Resend OTP Button
                      TextButton(
                        onPressed: controller.canResendOtp.value
                            ? () {
                                controller.getOtp();
                              }
                            : null, // Disable button until countdown is over
                        child: Text(
                          localLanguage.resend_otp,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(); // Hide elements if OTP process hasn't started
                }
              }),
              50.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      onPressed: controller.hasStartedOtpProcess.value
                          ? null // Disable the login button if OTP process has started
                          : () {
                              if (controller.loginFormKey.currentState?.saveAndValidate() ?? false) {
                                controller.getOtp();
                              }
                            },
                      child: Obx(() {
                        return Text(
                          controller.isLoading.value ? "${localLanguage.verifying}.." : localLanguage.verify_and_login,
                          style: TextStyle(fontSize: 14.sp),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

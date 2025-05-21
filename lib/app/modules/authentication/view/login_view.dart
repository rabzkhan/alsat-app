import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:alsat/l10n/app_localizations.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../app_home/view/app_home_view.dart';
import '../controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final bool isFromHome;
  const LoginView({super.key, this.isFromHome = false});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Get.theme.scaffoldBackgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Image.asset(
          textLogo,
          width: 160.w,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(180.h),
          child: Padding(
            padding: EdgeInsets.only(bottom: 35.h),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: Get.theme.disabledColor.withOpacity(0.05),
              child: InkWell(
                onTap: () async {
                  await MySharedPref.clear();
                },
                child: Image.asset(
                  loginLogo,
                  height: 100.h,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Get.theme.appBarTheme.backgroundColor!.withOpacity(0.7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.r),
            topRight: Radius.circular(60.r),
          ),
        ),
        child: FormBuilder(
          key: controller.loginFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            children: [
              40.verticalSpace,

              // Phone number input
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

              // OTP Countdown and Resend Button
              Obx(() {
                if (controller.hasStartedOtpProcess.value) {
                  final minutes = (controller.countdown.value ~/ 60)
                      .toString()
                      .padLeft(2, '0');
                  final seconds = (controller.countdown.value % 60)
                      .toString()
                      .padLeft(2, '0');
                  return Column(
                    children: [
                      20.verticalSpace,
                      Text(
                        controller.canResendOtp.value
                            ? ""
                            : "${localLanguage.resend_otp_in} $minutes:$seconds ${localLanguage.min}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              40.verticalSpace,
              // Submit button
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final isDisabled =
                          controller.hasStartedOtpProcess.value &&
                              !controller.canResendOtp.value;

                      return CupertinoButton.filled(
                        onPressed: isDisabled
                            ? null
                            : () {
                                if (controller.loginFormKey.currentState
                                        ?.saveAndValidate() ??
                                    false) {
                                  controller.getOtp(isFromHome: isFromHome);
                                }
                              },
                        child: Text(
                          controller.isLoading.value
                              ? "${localLanguage.verifying}.."
                              : localLanguage.verify_and_login,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              20.verticalSpace,

              // Guest login
              Obx(() {
                final isDisabled = controller.hasStartedOtpProcess.value &&
                    !controller.canResendOtp.value;
                return isDisabled
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              onPressed: () {
                                if (isFromHome) {
                                  Get.back();
                                } else {
                                  Get.offAll(const AppHomeView(),
                                      transition: Transition.fadeIn);
                                }
                              },
                              child: Text(
                                localLanguage.login_as_guest,
                                style: bold.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

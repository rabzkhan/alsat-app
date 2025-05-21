import 'dart:ui';
import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../config/theme/app_text_theme.dart';
import 'package:alsat/l10n/app_localizations.dart';

smsConfirmation(
    {required String phoneNumber,
    required String message,
    bool isFromHome = false}) {
  final localLanguage = AppLocalizations.of(Get.context!)!;
  Get.dialog(
    Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).r,
            color: Colors.white,
          ),
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Get.theme.disabledColor.withOpacity(.05),
                    child: Image.asset(
                      loginLogo,
                      height: 80.h,
                    ),
                  ),
                ),
                Text(
                  localLanguage.variy_your_number,
                  style: Get.theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                20.verticalSpace,
                Text(
                  localLanguage.to_authenticate,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                ),
                Text(
                  phoneNumber,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                ),
                20.verticalSpace,
                SizedBox(
                  height: 40.h,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Get.theme.primaryColor.withOpacity(.1),
                            side: BorderSide(
                              color: Get.theme.primaryColor,
                              width: 1,
                            ),
                            fixedSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            localLanguage.cancel,
                            style: regular.copyWith(
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            Get.find<AuthController>().isLoading.value = false;
                            Get.back();
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: const Size.fromHeight(48),
                            backgroundColor: Get.theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.find<AuthController>().sendSms(
                              phoneNumber,
                              message,
                              isFromHome: isFromHome,
                            );
                          },
                          child: Text(
                            localLanguage.send_message,
                            style: regular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                30.verticalSpace,
                Text(
                  localLanguage.by_continuing,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.grey.shade700),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

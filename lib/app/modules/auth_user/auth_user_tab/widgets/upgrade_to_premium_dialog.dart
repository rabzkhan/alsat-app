import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../../config/theme/app_text_theme.dart';
import '../../../../common/const/image_path.dart';
import '../../controller/user_controller.dart';
import 'package:alsat/l10n/app_localizations.dart';

upgradeToPremiumDialog() {
  final UserController userController = Get.find();
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
                Image.asset(
                  crownIcon,
                  width: 60.w,
                  height: 60.h,
                  color: Get.theme.primaryColor,
                ),
                Text(
                  localLanguage.unlock_premium,
                  style: Get.theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                6.verticalSpace,
                Text(
                  localLanguage.upgrade_code,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Pinput(
                    controller: userController.upgradeCodeController,
                    length: 8,
                    forceErrorState: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    defaultPinTheme: PinTheme(
                      width: 60.w,
                      height: 40.w,
                    ),
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 56.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    preFilledWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 56.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    onCompleted: (value) async {
                      log("onCompleted: $value");
                      await userController.upgradeToPremium();
                    },
                  ),
                ),
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
                            Get.back();
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        flex: 3,
                        child: Obx(
                          () {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size.fromHeight(48),
                                backgroundColor: Get.theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              onPressed: () async {
                                await userController.upgradeToPremium();
                              },
                              child:
                                  userController.isUpgradePreimumLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : Text(
                                          localLanguage.apply,
                                          style: regular.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                30.verticalSpace,
                Text(
                  localLanguage.dont_have_code,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

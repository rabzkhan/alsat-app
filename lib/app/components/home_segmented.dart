import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';
import '../modules/auth_user/auth_user_tab/widgets/upgrade_to_premium_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeSegmented extends StatelessWidget {
  const HomeSegmented({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final AuthController authController = Get.find();
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      height: 45.h,
      width: Get.width * 0.7,
      color: Get.theme.appBarTheme.backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return InkWell(
                onTap: () {
                  homeController.showPremium.value = false;
                },
                child: SizedBox(
                  height: 45.h,
                  child: PhysicalModel(
                    shadowColor: !homeController.showPremium.value
                        ? Get.theme.primaryColor
                        : Get.theme.disabledColor.withOpacity(.1),
                    color: Get.theme.appBarTheme.backgroundColor!,
                    elevation: 2,
                    shape: BoxShape.circle,
                    child: Container(
                      alignment: Alignment.center,
                      color: Get.theme.appBarTheme.backgroundColor!,
                      height: 45.h,
                      child: Text(
                        textAlign: TextAlign.center,
                        localLanguage.product,
                        style: regular.copyWith(
                          fontSize: 17.sp,
                          color: !homeController.showPremium.value ? Get.theme.primaryColor : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: Get.theme.disabledColor.withOpacity(.1),
          ),
          Expanded(
            child: Obx(() {
              return InkWell(
                onTap: () {
                  // if ((authController.userDataModel.value.premium ?? false)) {
                  //   upgradeToPremiumDialog();
                  // } else {
                  //   homeController.showPremium.value = true;
                  // }
                  homeController.showPremium.value = true;
                },
                child: SizedBox(
                  height: 45.h,
                  child: PhysicalModel(
                    // shadowColor: Get.theme.primaryColor,
                    shadowColor: homeController.showPremium.value
                        ? Get.theme.primaryColor
                        : Get.theme.disabledColor.withOpacity(.1),
                    color: Get.theme.appBarTheme.backgroundColor!,
                    elevation: 2,
                    shape: BoxShape.circle,
                    child: Container(
                      alignment: Alignment.center,
                      color: Get.theme.appBarTheme.backgroundColor!,
                      height: 45.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 14.r,
                            backgroundColor: Get.theme.secondaryHeaderColor.withOpacity(.5),
                            child: Image.asset(
                              crownIcon,
                              width: 18.w,
                              height: 20.h,
                              color: Get.theme.disabledColor.withOpacity(.1),
                            ),
                          ),
                          5.horizontalSpace,
                          Text(
                            textAlign: TextAlign.center,
                            localLanguage.premium,
                            style: regular.copyWith(
                              fontSize: 17.sp,
                              color: homeController.showPremium.value ? Get.theme.primaryColor : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

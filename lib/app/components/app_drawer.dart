// ignore_for_file: deprecated_member_use

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/conversation/view/message_view.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../config/theme/app_text_theme.dart';
import '../../config/translations/localization_controller.dart';
import '../modules/auth_user/auth_user_tab/my_settings.dart';
import '../modules/authentication/controller/auth_controller.dart';
import '../modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/l10n/app_localizations.dart';

import 'app_web_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    AuthController authController = Get.find();
    ConversationController conversationController = Get.find();
    LocalizationController localizationService =
        Get.put(LocalizationController());
    HomeController homeController = Get.find();
    return GlassmorphicContainer(
      width: Get.width * .6,
      height: double.infinity,
      blur: 20, // Blur effect
      border: 0, // No border
      borderRadius: 30, // Optional: Adjust the rounded corners
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.2), Colors.black.withOpacity(0.2)],
        stops: const [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.3), Colors.black.withOpacity(0.3)],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 20.h,
        ),
        child: Column(
          children: [
            50.verticalSpace,
            Obx(() {
              return homeController.isCategoryLoading.value
                  ? CupertinoActivityIndicator()
                  : authController.userDataModel.value.id == null
                      ? Center()
                      : ListTile(
                          onTap: () {
                            Get.back();
                            Get.to(() => const MySettings(),
                                transition: Transition.fadeIn);
                          },
                          leading: CircleAvatar(
                            radius: 22.r,
                            child: NetworkImagePreview(
                              radius: 22.r,
                              height: 45.h,
                              width: 45.w,
                              url: authController.userDataModel.value.picture ??
                                  "",
                              fit: BoxFit.cover,
                              error: Image.asset(userDefaultIcon),
                            ),
                          ),
                          title: Text(
                            authController.userDataModel.value.userName ?? "",
                            style: bold.copyWith(fontSize: 16.sp),
                          ),
                          subtitle: Text(
                            authController.userDataModel.value.phone ??
                                authController.userDataModel.value.email ??
                                "",
                          ),
                        );
            }),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(
                    //       const MyPromotionsView(),
                    //       transition: Transition.fadeIn,
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Image.asset(
                    //         crownIcon,
                    //         width: 25.w,
                    //         color: Get.theme.textTheme.bodyLarge!.color!,
                    //       ),
                    //       10.horizontalSpace,
                    //       Text(
                    //         'My Promotions',
                    //         style: regular.copyWith(
                    //           fontSize: 14.sp,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // 20.verticalSpace,
                    Obx(() {
                      return conversationController
                                  .adminConversationModel.value ==
                              null
                          ? const Center()
                          : InkWell(
                              onTap: () {
                                Get.to(
                                    () => MessagesScreen(
                                        conversation: conversationController
                                            .adminConversationModel.value!),
                                    transition: Transition.fadeIn);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    adminChat,
                                    width: 25.w,
                                    // color: Colors.white,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    localLanguage.chat_with_admin,
                                    style: semiBold,
                                  ),
                                ],
                              ),
                            );
                    }),
                    10.verticalSpace,
                    ExpansionTile(
                      shape:
                          const RoundedRectangleBorder(side: BorderSide.none),
                      tilePadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Image.asset(
                            translate,
                            width: 25.w,
                            // color: Colors.white,
                          ),
                          10.horizontalSpace,
                          Text(
                            localLanguage.change_language,
                            style: semiBold,
                          ),
                        ],
                      ),
                      childrenPadding: EdgeInsets.zero,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.centerLeft,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            localizationService
                                .changeLocale(const Locale('en'));
                            Get.back();
                          },
                          label: Text(
                            '🇺🇸 English',
                            style: regular.copyWith(
                              fontSize: 14.sp,
                              color: localizationService
                                          .locale.value.languageCode ==
                                      'en'
                                  ? AppColors.primary
                                  : Colors.white,
                              fontWeight: localizationService
                                          .locale.value.languageCode ==
                                      'en'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            localizationService
                                .changeLocale(const Locale('tr'));
                            Get.back();
                          },
                          label: Obx(
                            () => Text(
                              '🇹🇲 Turkmen',
                              style: regular.copyWith(
                                fontSize: 14.sp,
                                color: localizationService
                                            .locale.value.languageCode ==
                                        'tr'
                                    ? AppColors.primary
                                    : Colors.black54,
                                fontWeight: localizationService
                                            .locale.value.languageCode ==
                                        'tr'
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            localizationService
                                .changeLocale(const Locale('ru'));
                            Get.back();
                          },
                          label: Text(
                            '🇷🇺 Russian',
                            style: regular.copyWith(
                              fontSize: 14.sp,
                              color: localizationService
                                          .locale.value.languageCode ==
                                      'ru'
                                  ? AppColors.primary
                                  : Colors.black54,
                              fontWeight: localizationService
                                          .locale.value.languageCode ==
                                      'ru'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(
                          () => AppWebView(
                            url: "https://flutter.dev/",
                            title: localLanguage.user_agrement,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            termsCondition,
                            width: 25.w,
                            // color: Colors.white,
                          ),
                          10.horizontalSpace,
                          Text(
                            localLanguage.user_agrement,
                            style: semiBold,
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(() => AppWebView(
                              url: "https://flutter.dev/",
                              title: localLanguage.privacy_policy,
                            ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            privacyPolicy,
                            width: 25.w,
                            // color: Colors.white,
                          ),
                          10.horizontalSpace,
                          Text(
                            localLanguage.privacy_policy,
                            style: semiBold,
                          ),
                        ],
                      ),
                    ),

                    14.verticalSpace,
                    if (authController.userDataModel.value.id != null)
                      InkWell(
                        onTap: () {
                          Get.back();
                          authController.userLogOut(
                            isShowDialog: true,
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              // color: Colors.white,
                            ),
                            10.horizontalSpace,
                            Text(
                              localLanguage.logout,
                              style: semiBold,
                            ),
                          ],
                        ),
                      ),

                    120.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideX(
          duration: 600.ms,
          begin: -2,
          curve: Curves.fastOutSlowIn,
        );
  }
}

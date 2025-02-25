// ignore_for_file: deprecated_member_use

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/conversation/view/message_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../config/theme/app_text_theme.dart';
import '../../config/translations/localization_service.dart';
import '../modules/auth_user/auth_user_tab/my_settings.dart';
import '../modules/authentication/controller/auth_controller.dart';
import '../modules/conversation/controller/conversation_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    ConversationController conversationController = Get.find();
    LocalizationService localizationService = Get.put(LocalizationService());
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
                          url: authController.userDataModel.value.picture ?? "",
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
                                  .addminConversationModel.value ==
                              null
                          ? const Center()
                          : InkWell(
                              onTap: () {
                                Get.to(
                                    () => MessagesScreen(
                                        conversation: conversationController
                                            .addminConversationModel.value!),
                                    transition: Transition.fadeIn);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    adminChat,
                                    width: 25.w,
                                    color: Colors.grey.shade900,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    'Chat With Admin',
                                    style: regular.copyWith(
                                      fontSize: 14.sp,
                                    ),
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
                            color: Colors.grey.shade900,
                          ),
                          10.horizontalSpace,
                          Text(
                            'Language',
                            style: regular.copyWith(
                              fontSize: 14.sp,
                            ),
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
                          label: const Text('English'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            localizationService
                                .changeLocale(const Locale('tr'));
                            Get.back();
                          },
                          label: const Text('Turkmen'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            localizationService
                                .changeLocale(const Locale('ru'));
                            Get.back();
                          },
                          label: const Text('Russian'),
                        ),
                      ],
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

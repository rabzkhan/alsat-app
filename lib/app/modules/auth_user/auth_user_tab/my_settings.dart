import 'package:alsat/app/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../authentication/controller/auth_controller.dart';
import '../controller/user_controller.dart';
import 'widgets/upgrade_to_premium_dialog.dart';

class MySettings extends StatefulWidget {
  const MySettings({super.key});

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  final UserController userController = Get.find();
  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: const SafeArea(
          child: CustomAppBar(
            isShowBackButton: true,
            isShowFilter: false,
            isShowSearch: false,
            isShowNotification: false,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  //profile picture
                  SizedBox(
                    height: 140.h,
                    width: 140.h,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.r),
                          ),
                          child: Image.asset(
                            "assets/images/user-avatar.png",
                            height: 140.h,
                            width: 140.h,
                          ),
                        ),
                        Positioned(
                          bottom: 0.h,
                          right: 6.w,
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/icons/edit-profile.png",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  5.verticalSpace,
                  //name and phone
                  Obx(
                    () => Column(
                      children: [
                        Text(
                          authController.userDataModel.value.userName ?? 'Guest User',
                          style: bold.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          authController.userDataModel.value.phone ?? ' 01211312342',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          20.verticalSpace,
          FormBuilder(
            key: userController.userSettingsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Upgrade to premium",
                      style: bold,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        upgradeToPremiumDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              crownIcon,
                              width: 14.w,
                              height: 14.h,
                              color: Get.theme.primaryColor,
                            ),
                            5.horizontalSpace,
                            Text(
                              "Upgrade",
                              style: regular.copyWith(
                                fontSize: 12.sp,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                10.verticalSpace,
                Text(
                  "Account",
                  style: medium.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  enabled: false,
                  name: 'userName',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              crownIcon,
                              width: 14.w,
                              height: 14.h,
                              color: Get.theme.primaryColor,
                            ),
                            5.horizontalSpace,
                            Text(
                              "Premium",
                              style: regular.copyWith(
                                fontSize: 12.sp,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  name: 'location',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: Icon(
                      Icons.keyboard_arrow_right,
                      size: 14.h,
                      color: AppColors.primary,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  name: 'category',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: Icon(
                      Icons.keyboard_arrow_right,
                      size: 14.h,
                      color: AppColors.primary,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Category',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                20.verticalSpace,
                Text(
                  "Social",
                  style: medium.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  name: 'youtube',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: Image.asset(
                      youtubeIcon,
                      width: 14.w,
                      height: 14.h,
                      color: Get.theme.primaryColor,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Youtube',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  name: 'tiktok',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: Image.asset(
                      tiktokIcon,
                      width: 14.w,
                      height: 14.h,
                      color: Get.theme.primaryColor,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Tiktok',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
                20.verticalSpace,
                FormBuilderTextField(
                  name: 'twitch',
                  controller: userController.userNameTextController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffix: Image.asset(
                      twitchIcon,
                      width: 14.w,
                      height: 14.h,
                      color: Get.theme.primaryColor,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Twitch',
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.shadowColor.withOpacity(.6),
                    ),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                  ),
                  validator: FormBuilderValidators.compose(
                    [],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

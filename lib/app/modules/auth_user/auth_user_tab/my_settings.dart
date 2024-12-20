import 'dart:developer';
import 'dart:io';

import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/network_image_preview.dart';
import '../../app_home/controller/home_controller.dart';
import '../../authentication/controller/auth_controller.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/location_selection.dart';
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
  HomeController homeController = Get.find();
  FilterController filterController = Get.find();
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
        padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(bottom: 20.h),
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
                        CircleAvatar(
                          radius: 70.r,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.r),
                              ),
                              child: Obx(() {
                                return authController
                                        .isProfilePictureLoading.value
                                    ? const CircularProgressIndicator()
                                    : authController
                                                .userDataModel.value.picture ==
                                            null
                                        ? Image.asset(
                                            "assets/images/user-avatar.png",
                                            height: 140.h,
                                            width: 140.h,
                                          )
                                        : NewworkImagePreview(
                                            url: authController.userDataModel
                                                    .value.picture ??
                                                '',
                                            height: 140.h,
                                            width: 140.h,
                                            fit: BoxFit.cover,
                                          );
                              }),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.h,
                          right: 6.w,
                          child: IconButton(
                            onPressed: () async {
                              List<AssetEntity>? pickImage =
                                  await AssetPicker.pickAssets(
                                context,
                                pickerConfig: const AssetPickerConfig(
                                  maxAssets: 1,
                                  requestType: RequestType.image,
                                ),
                              );
                              if (pickImage != null) {
                                // log("image path ${pickImage[0].file.path}");
                                File? file = await pickImage.first.file;
                                await authController
                                    .updateProfilePicture(file!);
                              }
                            },
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
                          authController.userDataModel.value.userName ??
                              'Guest User',
                          style: bold.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          authController.userDataModel.value.phone ??
                              ' 01211312342',
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
                Obx(() {
                  return (authController.userDataModel.value.premium ?? false)
                      ? const Center()
                      : Row(
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
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 6.w),
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
                        );
                }),
                10.verticalSpace,
                Text(
                  "Account",
                  style: medium.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                20.verticalSpace,
                Obx(() {
                  return FormBuilderTextField(
                    initialValue: authController.userDataModel.value.userName,
                    enabled:
                        (authController.userDataModel.value.premium ?? false),
                    name: 'userName',
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffix: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 6.w),
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
                  );
                }),
                20.verticalSpace,
                GestureDetector(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          const LocationSelection(canSelectMultiple: false),
                    ).then((value) {
                      authController.selectedCity.value =
                          filterController.selectedCity.value;
                      authController.selectedProvince.value =
                          filterController.selectedProvince.value;
                      authController.addressController.text =
                          '${authController.selectedProvince.value}, ${authController.selectedCity.value}';
                      authController.selectedCity.refresh();
                      authController.selectedProvince.refresh();
                    });
                  },
                  child: FormBuilderTextField(
                    controller: authController.addressController,
                    enabled: false,
                    name: 'location',
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
                ),
                20.verticalSpace,
                FormBuilderSearchableDropdown<CategoriesModel>(
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      authController.selectUsewrCategoriesList
                          .map((e) => e.name)
                          .toList()
                          .join(","),
                    );
                  },
                  compareFn: (a, b) => a.sId == b.sId,
                  items: homeController.categories,
                  popupProps: PopupProps.menu(
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(
                          item.name ?? "",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Obx(() {
                            return Icon(
                              Icons.check,
                              color: authController.selectUsewrCategoriesList
                                      .contains(item)
                                  ? AppColors.primary
                                  : Colors.transparent,
                            );
                          }),
                        ),
                      );
                    },
                    showSearchBox: false,
                    fit: FlexFit.loose,
                    showSelectedItems: true,
                  ),
                  name: 'category',
                  onChanged: (value) {
                    if (authController.selectUsewrCategoriesList
                        .contains(value)) {
                      authController.selectUsewrCategoriesList.remove(value);
                    } else {
                      authController.selectUsewrCategoriesList.add(value!);
                    }
                    authController.selectUsewrCategoriesList.refresh();
                  },
                  decoration: InputDecoration(
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
                  // validator: FormBuilderValidators.compose(),
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
                40.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size.fromHeight(48),
                          backgroundColor: Get.theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {},
                        child: false
                            ? const CupertinoActivityIndicator()
                            : Text(
                                "Save",
                                style: regular.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Delete Account",
                        textAlign: TextAlign.center,
                        style: regular,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

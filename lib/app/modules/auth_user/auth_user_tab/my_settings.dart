import 'dart:developer';
import 'dart:io';

import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/components/custom_snackbar.dart';
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
  void initState() {
    filterController.clearAddress();
    Future.microtask(() {
      authController.selectUserCategoriesList.value = homeController.categories
          .where((e) => (authController.userDataModel.value.categories ?? []).contains(e.name))
          .toList();
      filterController.selectedProvince.value = authController.userDataModel.value.location?.province ?? "";
      filterController.selectedCity.value = authController.userDataModel.value.location?.city ?? "";
      authController.selectUserCategoriesList.refresh();
      authController.addressController.text =
          "${authController.userDataModel.value.location?.province ?? ''}, ${authController.userDataModel.value.location?.city ?? ""}";

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    filterController.clearAddress();
    super.dispose();
  }

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
                                return authController.isProfilePictureLoading.value
                                    ? const CircularProgressIndicator()
                                    : authController.userDataModel.value.picture == null
                                        ? Image.asset(
                                            userDefaultIcon,
                                            height: 140.h,
                                            width: 140.h,
                                          )
                                        : NetworkImagePreview(
                                            url: authController.userDataModel.value.picture ?? '',
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
                              List<AssetEntity>? pickImage = await AssetPicker.pickAssets(
                                context,
                                pickerConfig: const AssetPickerConfig(
                                  maxAssets: 1,
                                  requestType: RequestType.image,
                                ),
                              );
                              if (pickImage != null) {
                                // log("image path ${pickImage[0].file.path}");
                                File? file = await pickImage.first.file;
                                await authController.updateProfilePicture(file!);
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
                          authController.userDataModel.value.userName ?? 'Guest User',
                          style: bold.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          authController.userDataModel.value.phone ?? '',
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
            initialValue: {
              'category': homeController.categories
                  .where((e) => (authController.userDataModel.value.categories ?? []).contains(e.name))
                  .toList()
                  .firstOrNull,
              'bio': authController.userDataModel.value.bio ?? '',
              // 'youtube':
              //     authController.userDataModel.value.messaging?.firstWhereOrNull((e) => e.type == 'youtube')?.id ?? '',
              // 'tiktok':
              //     authController.userDataModel.value.messaging?.firstWhereOrNull((e) => e.type == 'tiktok')?.id ?? '',
              // 'twitch':
              //     authController.userDataModel.value.messaging?.firstWhereOrNull((e) => e.type == 'twitch')?.id ?? '',
            },
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
                    enabled: (authController.userDataModel.value.premium ?? false),
                    name: 'user_name',
                    keyboardType: TextInputType.text,
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
                                "Premiums",
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
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  );
                }),
                20.verticalSpace,
                Obx(
                  () => FormBuilderTextField(
                    enabled: (authController.userDataModel.value.premium ?? false),
                    maxLines: 3,
                    name: 'bio',
                    decoration: InputDecoration(
                      isDense: true,
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'About Me',
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
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => InkWell(
                    onTap: () {
                      if ((authController.userDataModel.value.premium ?? false)) {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const LocationSelection(canSelectMultiple: false),
                        ).then((value) {
                          if (value != null) {
                            authController.addressController.text = filterController.getSelectedLocationText();
                          }
                        });
                      }
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: FormBuilderTextField(
                        controller: authController.addressController,
                        enabled: (authController.userDataModel.value.premium ?? false),
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
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => FormBuilderSearchableDropdown<CategoriesModel>(
                    dropdownBuilder: (context, selectedItem) {
                      return Obx(() {
                        return Text(
                          authController.selectUserCategoriesList.map((e) => e.name).toList().join(","),
                        );
                      });
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
                                color: authController.selectUserCategoriesList.contains(item)
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
                    enabled: (authController.userDataModel.value.premium ?? false),
                    name: 'category',
                    onChanged: (value) {
                      if (authController.selectUserCategoriesList.contains(value)) {
                        authController.selectUserCategoriesList.remove(value);
                      } else {
                        if (authController.selectUserCategoriesList.length == 3) {
                          CustomSnackBar.showCustomToast(
                            color: Colors.red,
                            message: 'You can select only 3 categories',
                          );
                        } else {
                          authController.selectUserCategoriesList.add(value!);
                        }
                      }
                      authController.selectUserCategoriesList.refresh();
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
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                // Text(
                //   "Social",
                //   style: medium.copyWith(
                //     color: Colors.grey.shade800,
                //   ),
                // ),
                // 20.verticalSpace,
                // FormBuilderTextField(
                //   name: 'youtube',
                //   decoration: InputDecoration(
                //     suffix: Image.asset(
                //       youtubeIcon,
                //       width: 14.w,
                //       height: 14.h,
                //       color: Get.theme.primaryColor,
                //     ),
                //     isDense: true,
                //     alignLabelWithHint: true,
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     labelText: 'Youtube',
                //     labelStyle: TextStyle(
                //       fontSize: 14.sp,
                //       color: Get.theme.shadowColor.withOpacity(.6),
                //     ),
                //     border: outlineBorder,
                //     enabledBorder: outlineBorder,
                //     errorBorder: outlineBorder,
                //     focusedBorder: outlineBorder,
                //   ),
                //   // validator: FormBuilderValidators.compose(
                //   //   [],
                //   // ),
                // ),
                // 20.verticalSpace,
                // FormBuilderTextField(
                //   name: 'tiktok',
                //   decoration: InputDecoration(
                //     suffix: Image.asset(
                //       tiktokIcon,
                //       width: 14.w,
                //       height: 14.h,
                //       color: Get.theme.primaryColor,
                //     ),
                //     isDense: true,
                //     alignLabelWithHint: true,
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     labelText: 'Tiktok',
                //     labelStyle: TextStyle(
                //       fontSize: 14.sp,
                //       color: Get.theme.shadowColor.withOpacity(.6),
                //     ),
                //     border: outlineBorder,
                //     enabledBorder: outlineBorder,
                //     errorBorder: outlineBorder,
                //     focusedBorder: outlineBorder,
                //   ),
                //   // validator: FormBuilderValidators.compose(
                //   //   [],
                //   // ),
                // ),
                // 20.verticalSpace,
                // FormBuilderTextField(
                //   name: 'twitch',
                //   decoration: InputDecoration(
                //     suffix: Image.asset(
                //       twitchIcon,
                //       width: 14.w,
                //       height: 14.h,
                //       color: Get.theme.primaryColor,
                //     ),
                //     isDense: true,
                //     alignLabelWithHint: true,
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     labelText: 'Twitch',
                //     labelStyle: TextStyle(
                //       fontSize: 14.sp,
                //       color: Get.theme.shadowColor.withOpacity(.6),
                //     ),
                //     border: outlineBorder,
                //     enabledBorder: outlineBorder,
                //     errorBorder: outlineBorder,
                //     focusedBorder: outlineBorder,
                //   ),
                //   // validator: FormBuilderValidators.compose(
                //   //   [],
                //   // ),
                // ),

                10.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: const Size.fromHeight(48),
                            backgroundColor: Get.theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: authController.isUpdateLoading.value
                              ? null
                              : () {
                                  if (userController.userSettingsFormKey.currentState!.saveAndValidate()) {
                                    Map formData = userController.userSettingsFormKey.currentState!.value;
                                    Map<String, dynamic> data = {
                                      // "messaging": [
                                      //   {"id": formData['youtube'] ?? "No Link", "type": "youtube"},
                                      //   {"id": formData['tiktok'] ?? "No Link", "type": "tiktok"},
                                      //   {"id": formData['twitch'] ?? "No Link", "type": "twitch"}
                                      // ], // max 3

                                      "bio": formData['bio'] ?? "",
                                      "user_name": formData['user_name'] ?? "",
                                      "categories": authController.selectUserCategoriesList.map((e) => e.name).toList(),
                                    };

                                    if (authController.addressController.text.isNotEmpty) {
                                      data.addAll({
                                        "location": {
                                          "province": authController.addressController.text.split(",").firstOrNull ??
                                              authController.userDataModel.value.location?.province ??
                                              "",
                                          "city": authController.addressController.text.split(",").elementAtOrNull(1) ??
                                              authController.userDataModel.value.location?.city ??
                                              "",
                                          "geo": {
                                            "type": "point",
                                            "coordinates": [45, 5]
                                          }
                                        },
                                      });
                                    }

                                    authController.updateUserInformation(data: data);
                                  }
                                },
                          child: authController.isUpdateLoading.value
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  "Save",
                                  style: regular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      }),
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

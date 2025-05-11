import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/modules/filter/views/location_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/scrolling_text.dart';
import '../../../global/app_decoration.dart';
import '../../product/widget/category_selection.dart';
import 'user_filter_result_view.dart';

class UserFilterView extends StatelessWidget {
  const UserFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    HomeController homeController = Get.find();
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: Colors.amberAccent.shade100,
                child: Image.asset(
                  crownIcon,
                  height: 15.h,
                  width: 15.w,
                  color: Colors.amber,
                ),
              ),
              4.horizontalSpace,
              Text(
                localLanguage.find_users,
                textAlign: TextAlign.center,
                style: regular.copyWith(
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
          //-- select category--//
          GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const CategorySelection(valueReturn: true),
              ).then((value) {
                homeController.category.value = value;
                // productController.calculateFilledProductFields();
              });
            },
            child: Container(
              decoration: borderedContainer,
              margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 14.h),
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        localLanguage.category,
                        style: bold.copyWith(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                      2.verticalSpace,
                      Obx(() {
                        return Text(
                          (homeController.category.value?.name ?? localLanguage.select_category).toString(),
                          style: bold.copyWith(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        );
                      }),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 30.h,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),
          ), //-- select Location--//
          //-- select Location--//
          GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const LocationSelection(canSelectMultiple: true),
              );
            },
            child: Container(
              decoration: borderedContainer,
              margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          localLanguage.location,
                          style: bold.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        2.verticalSpace,
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: ScrollingTextWidget(
                                  child: Text(
                                    Get.find<FilterController>().getSelectedLocationText(),
                                    style: regular.copyWith(
                                      fontSize: 10.sp,
                                      color: context.theme.primaryColor,
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
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 30.h,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),
          ),
          15.verticalSpace,
          //--Follower -- and -- Register --//
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                        color: AppColors.liteGray,
                        width: 1.w,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColors.liteGray,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    title: Text(
                      localLanguage.followers,
                      style: bold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Obx(() {
                      return Text(
                        homeController.followersValue.value ?? localLanguage.not_chosen_yet,
                        style: regular.copyWith(fontSize: 10.sp),
                      );
                    }),
                    dense: true,
                    children: [
                      const Divider(
                        color: AppColors.primary,
                        height: 1,
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                localLanguage.min_to_max,
                                style: regular.copyWith(fontSize: 12.sp),
                              ),
                            ),
                            Obx(() {
                              return Radio(
                                visualDensity: const VisualDensity(vertical: -2),
                                value: 'Min To Max',
                                groupValue: homeController.followersValue.value,
                                onChanged: (value) {
                                  homeController.followersValue.value = value;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                localLanguage.max_to_min,
                                style: regular.copyWith(fontSize: 12.sp),
                              ),
                            ),
                            Obx(() {
                              return Radio(
                                visualDensity: const VisualDensity(vertical: -2),
                                value: 'Max To Min',
                                groupValue: homeController.followersValue.value,
                                onChanged: (value) {
                                  homeController.followersValue.value = value;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                        color: AppColors.liteGray,
                        width: 1.w,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColors.liteGray,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    title: Text(
                      localLanguage.registration,
                      style: bold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Obx(() {
                      return Text(
                        homeController.registrationValue.value ?? localLanguage.not_chosen_yet,
                        style: regular.copyWith(fontSize: 10.sp),
                      );
                    }),
                    dense: true,
                    children: [
                      const Divider(
                        color: AppColors.primary,
                        height: 1,
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                localLanguage.new_to_old,
                                style: regular.copyWith(fontSize: 12.sp),
                              ),
                            ),
                            Obx(() {
                              return Radio(
                                visualDensity: const VisualDensity(vertical: -2),
                                value: 'New To Old',
                                groupValue: homeController.registrationValue.value,
                                onChanged: (value) {
                                  homeController.registrationValue.value = value;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                localLanguage.old_to_new,
                                style: regular.copyWith(fontSize: 12.sp),
                              ),
                            ),
                            Obx(() {
                              return Radio(
                                visualDensity: const VisualDensity(vertical: -2),
                                value: 'Old To New',
                                groupValue: homeController.registrationValue.value,
                                onChanged: (value) {
                                  homeController.registrationValue.value = value;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          15.verticalSpace,
          // Obx(() {
          //   return SwitchListTile(
          //     title: Text(
          //       localLanguage.active_account,
          //       style: bold.copyWith(
          //         fontSize: 14.sp,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     value: homeController.isActiveUser.value,
          //     dense: true,
          //     onChanged: (value) {
          //       homeController.isActiveUser.value = value;
          //     },
          //     controlAffinity: ListTileControlAffinity.trailing,
          //   );
          // }),
          Obx(() {
            return SwitchListTile(
                title: Text(
                  localLanguage.buyer_protection,
                  style: bold.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: homeController.buyerProtection.value,
                dense: true,
                onChanged: (value) {
                  homeController.buyerProtection.value = value;
                });
          }),
          30.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: Obx(() {
                      return ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              homeController.category.value == null ? AppColors.liteGray : AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          Get.to(const UserFilterResultView(), transition: Transition.cupertino);
                          homeController.fetchPremiumUser(isFilter: true);
                        },
                        child: Obx(() {
                          if (homeController.isPremiumLoading.value) {
                            return SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return Text(
                            localLanguage.filter,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../components/all_user_tile.dart';
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../conversation/controller/conversation_controller.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/user_filter_result_view.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';
import '../view/premium_categories_view.dart';
import 'package:alsat/l10n/app_localizations.dart';

class PremiumContent extends StatelessWidget {
  const PremiumContent({super.key});

  @override
  Widget build(BuildContext context) {
    // final productController = Get.find<ProductController>();
    final localLanguage = AppLocalizations.of(Get.context!)!;
    final HomeController homeController = Get.find();
    final ConversationController _ = Get.find();
    FilterController filterController = Get.find();

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: CustomHeaderWidget(),
      footer: CustomFooterWidget(),
      controller: homeController.premiumRefreshController,
      onRefresh: homeController.onPremiumRefresh,
      onLoading: homeController.onPremiumLoading,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          //--- Category ---//
          Row(
            children: [
              15.horizontalSpace,
              Expanded(
                child: Text(
                  localLanguage.popular_categories,
                  style: Get.textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(
                      () => const PremiumCategoriesView(isFromPremium: true));
                },
                child: Text(
                  localLanguage.see_all,
                  style: Get.textTheme.titleSmall,
                ),
              ),
              5.horizontalSpace,
            ],
          ),
          SizedBox(
            height: 68.h,
            child: Obx(() {
              List<CategoriesModel> filteredCategories =
                  homeController.isCategoryLoading.value
                      ? List.generate(10, (_) => CategoriesModel())
                      : homeController.categories.where((category) {
                          final name = category.name?.toLowerCase() ?? '';
                          return !name.startsWith('free') &&
                              !name.startsWith('lost');
                        }).toList();
              return Skeletonizer(
                enabled: homeController.isCategoryLoading.value,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                  separatorBuilder: (context, index) => 10.horizontalSpace,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    CategoriesModel categoriesModel = filteredCategories[index];
                    return GestureDetector(
                      onTap: () {
                        homeController.category.value = categoriesModel;
                        homeController.fetchFilterPremiumUser();
                        filterController.clearAddress();
                        Get.to(
                          const UserFilterResultView(isBackFilter: false),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
                        height: 70.h,
                        width: 100.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            6.verticalSpace,
                            SvgPicture.network(
                              categoriesModel.icon.toString(),
                              width: 35.w,
                              height: 22.w,
                              placeholderBuilder: (context) =>
                                  const CupertinoActivityIndicator
                                      .partiallyRevealed(),
                            ),
                            5.verticalSpace,
                            Text(
                              categoriesModel.name ?? "",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            5.verticalSpace,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          //--- Premium Content ---//

          Padding(
            padding: EdgeInsets.only(
                top: 15.h, left: 15.w, right: 15.w, bottom: 15.h),
            child: TextFormField(
              controller: homeController.searchController,
              onFieldSubmitted: (value) {
                homeController.fetchFilterPremiumUser();
                filterController.clearAddress();
                Get.to(
                  const UserFilterResultView(isBackFilter: false),
                  transition: Transition.rightToLeft,
                );
              },
              onChanged: (value) {
                homeController.searchText.value = value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Get.theme.disabledColor,
                ),
                suffixIcon: Obx(() {
                  return homeController.searchText.isEmpty
                      ? InkWell(
                          onTap: () {
                            filterController.clearAddress();
                            homeController.category.value = null;
                            homeController.fetchFilterPremiumUser();
                            Get.to(
                              const UserFilterResultView(isBackFilter: false),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Center(
                              child: Image.asset(
                                height: 20.h,
                                width: 20.w,
                                filterIcon,
                                color: Get.theme.disabledColor,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                homeController.searchController.clear();
                                homeController.searchText.value = "";
                              },
                              child: Icon(
                                Icons.clear,
                                size: 18.r,
                              ),
                            ),
                            8.horizontalSpace,
                            InkWell(
                              onTap: () {
                                filterController.clearAddress();
                                homeController.category.value = null;
                                homeController.fetchFilterPremiumUser();
                                Get.to(
                                  const UserFilterResultView(
                                      isBackFilter: false),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: CircleAvatar(
                                radius: 16.r,
                                child: Icon(
                                  CupertinoIcons.search,
                                  size: 18.r,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                          ],
                        );
                }),
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Get.theme.disabledColor.withOpacity(.5),
                ),
                hintText: localLanguage.find_users,
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.theme.disabledColor.withOpacity(.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.theme.disabledColor.withOpacity(.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.theme.primaryColor.withOpacity(.4),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            return Skeletonizer(
              enabled: homeController.isPremiumLoading.value,
              child: ListView.builder(
                itemCount: homeController.isPremiumLoading.value
                    ? 10
                    : homeController.premiumUserList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  UserDataModel premiumUserModel =
                      homeController.isPremiumLoading.value
                          ? UserDataModel()
                          : homeController.premiumUserList[index];
                  return AllUserTile(premiumUserModel: premiumUserModel);
                },
              ),
            );
          })
        ],
      ),
    );
  }
}

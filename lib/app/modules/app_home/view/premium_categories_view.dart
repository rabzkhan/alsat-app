// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/user_filter_result_view.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumCategoriesView extends StatelessWidget {
  const PremiumCategoriesView({
    super.key,
    this.isFromPremium = false,
  });
  final bool isFromPremium;
  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    final HomeController homeController = Get.find();
    FilterController filterController = Get.find<FilterController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          localLanguage.category,
          style: Get.textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Obx(
          () {
            final allCategories = homeController.categories;
            final filteredCategories = isFromPremium
                ? allCategories.where((cat) {
                    final name = cat.name?.toLowerCase() ?? '';
                    return !name.startsWith('free of') && !name.startsWith('lost and found');
                  }).toList()
                : allCategories;

            return Skeletonizer(
              enabled: homeController.isCategoryLoading.value,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: homeController.isCategoryLoading.value ? 10 : filteredCategories.length,
                itemBuilder: (context, index) {
                  final categoriesModel =
                      homeController.isCategoryLoading.value ? CategoriesModel() : filteredCategories[index];

                  return GestureDetector(
                    onTap: () {
                      homeController.category.value = categoriesModel;
                      homeController.fetchPremiumUser(isFilter: false);
                      filterController.clearAddress();
                      Get.to(
                        const UserFilterResultView(isBackFilter: false),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Container(
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
                            placeholderBuilder: (context) => const CupertinoActivityIndicator.partiallyRevealed(),
                          ),
                          5.verticalSpace,
                          Text(
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            categoriesModel.name ?? "",
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
          },
        ),
      ),
    );
  }
}

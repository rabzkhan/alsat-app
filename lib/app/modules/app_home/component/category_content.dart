import 'dart:developer';

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../filter/views/filter_results_view.dart';
import '../../filter/views/filter_view.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    FilterController filterController = Get.find();
    return RefreshIndicator(
      onRefresh: () async {
        homeController.getCategories();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            if (homeController.isCategoryLoading.value) {
              return SizedBox(
                height: Get.height * .8,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const FilterView(
                        isBack: false,
                        preData: {},
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    width: Get.width,
                    height: 50.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: Get.theme.disabledColor.withOpacity(.03),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Get.theme.disabledColor.withOpacity(.1),
                      ),
                    ),
                    child: Row(
                      // spacing: 10.w,
                      children: [
                        Image.asset(
                          searchIcon,
                          color: Get.theme.disabledColor,
                        ),
                        10.horizontalSpace,
                        Text(
                          "Search Your Product",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Get.theme.disabledColor.withOpacity(.5),
                          ),
                        ),
                        const Spacer(),
                        10.horizontalSpace,
                        Image.asset(
                          filterIcon,
                          color: Get.theme.disabledColor,
                        ),
                      ],
                    ),
                  ),
                ),
                ...List.generate(
                  homeController.categories.length,
                  (index) => ExpansionTile(
                    title: GestureDetector(
                      onTap: () {
                        filterController.isFilterLoading.value = true;
                        filterController.filtermapPassed = {
                          "category":
                              (homeController.categories[index].name ?? '')
                                  .toLowerCase(),
                        };
                        filterController.applyFilter();
                        Get.to(
                          const FilterResultsView(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Row(
                        children: [
                          6.horizontalSpace,
                          SvgPicture.network(
                            placeholderBuilder: (context) =>
                                const CupertinoActivityIndicator
                                    .partiallyRevealed(),
                            homeController.categories[index].icon.toString(),
                            width: 35.w,
                            height: 22.w,
                          ),
                          10.horizontalSpace,
                          Text(
                            homeController.categories[index].name ?? "",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    expandedAlignment: Alignment.centerLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: Get.width * .12),
                    children: [
                      ...(homeController.categories[index].subCategories ?? [])
                          .map((subCategory) {
                        return GestureDetector(
                          onTap: () {
                            filterController.isFilterLoading.value = true;
                            filterController.filtermapPassed = {
                              "category":
                                  (homeController.categories[index].name ?? '')
                                      .toLowerCase(),
                            };
                            filterController.applyFilter();
                            Get.to(
                              const FilterResultsView(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 10.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    subCategory.name.toString(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

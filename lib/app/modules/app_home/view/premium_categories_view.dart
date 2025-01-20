import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../filter/views/user_filter_result_view.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';

class PremiumCategoriesView extends StatelessWidget {
  const PremiumCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Premium Categories",
          style: Get.textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Obx(
          () {
            return Skeletonizer(
              enabled: homeController.isCategoryLoading.value,
              effect: ShimmerEffect(
                baseColor: Get.theme.disabledColor.withOpacity(.2),
                highlightColor: Colors.white,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: homeController.isCategoryLoading.value
                    ? 10
                    : homeController.categories.length,
                itemBuilder: (context, index) {
                  CategoriesModel categoriesModel =
                      homeController.isCategoryLoading.value
                          ? CategoriesModel()
                          : homeController.categories[index];
                  return GestureDetector(
                    onTap: () {
                      homeController.category.value =
                          homeController.categories[index];
                      homeController.fetchPremiumUser(isFilter: true);
                      Get.to(
                        const UserFilterResultView(isBackFilter: false),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
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

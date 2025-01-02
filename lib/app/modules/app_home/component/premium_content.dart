import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/app_home/component/home_content.dart';
import 'package:alsat/app/modules/authentication/model/user_data_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../components/all_user_tile.dart';
import '../../conversation/controller/conversation_controller.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/filter_results_view.dart';
import '../../filter/views/user_filter_result_view.dart';
import '../../filter/views/user_filter_view.dart';
import '../../product/controller/product_controller.dart';
import '../../product/controller/product_details_controller.dart';
import '../../product/view/client_profile_view.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';

class PremiumContent extends StatelessWidget {
  const PremiumContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final HomeController homeController = Get.find();
    final ConversationController _ = Get.find();
    FilterController filterController = Get.find();
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(
        waterDropColor: context.theme.primaryColor,
      ),
      controller: homeController.premiumRefreshController,
      onRefresh: homeController.onPremiumRefresh,
      onLoading: homeController.onPremiumLoading,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //--- Category ---//
          SizedBox(
            height: 68.h,
            child: Obx(() {
              return Skeletonizer(
                enabled: homeController.isCategoryLoading.value,
                effect: ShimmerEffect(
                  baseColor: Get.theme.disabledColor.withOpacity(.2),
                  highlightColor: Colors.white,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                  separatorBuilder: (context, index) => 10.horizontalSpace,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
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
                        height: 70.h,
                        width: 100.h,
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
            }),
          ),
          //--- Premium Content ---//

          InkWell(
            onTap: () {
              Get.to(
                const UserFilterView(),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
              width: Get.width,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    "Find Users",
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

          Obx(() {
            return Skeletonizer(
              enabled: homeController.isPremiumLoading.value,
              effect: ShimmerEffect(
                baseColor: Get.theme.disabledColor.withOpacity(.2),
                highlightColor: Colors.white,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
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

// ignore_for_file: deprecated_member_use

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alsat/app/modules/app_home/component/premium_content.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/app_home/models/banner_res.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/app/modules/story/component/home_story_section.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../../utils/loading_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../../components/custom_snackbar.dart';
import '../../../components/home_segmented.dart';
import '../../../components/network_image_preview.dart';
import '../../../components/product_list_tile.dart';
import '../../conversation/controller/conversation_controller.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/filter_results_view.dart';
import '../../product/controller/product_details_controller.dart';
import '../../product/model/product_post_list_res.dart';
import '../../product/view/client_profile_view.dart';
import '../../product/view/product_details_view.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final productController = Get.find<ProductController>();
    final ConversationController _ = Get.find();
    FilterController filterController = Get.find();

    return Column(
      children: [
        const HomeSegmented(),
        Expanded(
          child: Obx(
            () {
              return homeController.showPremium.value
                  ? const PremiumContent()
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: CustomHeaderWidget(),
                      footer: CustomFooterWidget(),
                      controller: productController.homeRefreshController,
                      onRefresh: productController.onHomeRefresh,
                      onLoading: productController.onHomeLoading,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          //-- HOME SLIDER --//
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                            ).copyWith(
                              top: 10.h,
                            ),
                            child: Skeletonizer(
                              enabled: homeController.isBannerLoading.value,
                              effect: ShimmerEffect(
                                baseColor: AppColors.primary.withOpacity(.2),
                                highlightColor: AppColors.primary.withOpacity(.5),
                              ),
                              child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 190.h,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.9,
                                    initialPage: 0,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(seconds: 3),
                                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,

                                    // onPageChanged: callbackFunction,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: List.generate(
                                    homeController.isBannerLoading.value ? 5 : homeController.mainBanner.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        onBannerTab(
                                          homeController,
                                          productController,
                                          filterController,
                                          homeController.mainBanner[index],
                                        );
                                      },
                                      child: SizedBox(
                                        height: 190.h,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            NetworkImagePreview(
                                              radius: 3.r,
                                              url: homeController.isBannerLoading.value
                                                  ? ''
                                                  : homeController.mainBanner[index].media?.name ?? '',
                                              height: 200.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              top: 10.h,
                                              child: Container(
                                                height: 20.h,
                                                // width: 60.w,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: context.theme.scaffoldBackgroundColor.withOpacity(.8),
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(5.r),
                                                    bottomRight: Radius.circular(5.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  homeController.isBannerLoading.value
                                                      ? ""
                                                      : '${homeController.mainBanner[index].type}'.toUpperCase(),
                                                  style: regular.copyWith(
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          //-- Stroy Section
                          const HomeStorySection(),

                          /// other banner
                          Skeletonizer(
                            enabled: homeController.isBannerLoading.value,
                            // effect: ShimmerEffect(
                            //   baseColor: Get.theme.disabledColor.withOpacity(.2),
                            //   highlightColor: Colors.white,
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            // ),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  homeController.isBannerLoading.value ? 2 : homeController.otherBanner.take(2).length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    onBannerTab(homeController, productController, filterController,
                                        homeController.otherBanner[index]);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: NetworkImagePreview(
                                      radius: 10.r,
                                      url: homeController.isBannerLoading.value
                                          ? ''
                                          : homeController.otherBanner[index].media?.name ?? '',
                                      height: 120.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          //-- home Product ---//
                          ListView.builder(
                            itemCount:
                                productController.isFetchProduct.value ? 10 : productController.productList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ProductModel? productModel =
                                  productController.isFetchProduct.value ? null : productController.productList[index];
                              return Skeletonizer(
                                enabled: productController.isFetchProduct.value,
                                // effect: ShimmerEffect(
                                //   baseColor: Get.theme.disabledColor.withOpacity(.2),
                                //   highlightColor: Colors.white,
                                //   begin: Alignment.centerLeft,
                                //   end: Alignment.centerRight,
                                // ),
                                child: ProductListTile(
                                  productModel: productModel,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}

onBannerTab(HomeController homeController, ProductController productController, FilterController filterController,
    BannerModel bannerModel) {
  final localLanguage = AppLocalizations.of(Get.context!)!;
  //if product
  if ('${bannerModel.type}'.toUpperCase() == 'POST') {
    showLoading();
    productController.getSingleProductDetails(bannerModel.entityId ?? "").then((_) {
      Get.back();
      if (productController.selectPostProductModel.value?.id == null) {
        CustomSnackBar.showCustomToast(message: localLanguage.product_not_found);
      } else {
        Get.to(
            ProductDetailsView(
              productModel: productController.selectPostProductModel.value,
            ),
            transition: Transition.fadeIn);
      }
    });
  }
  // IF USER
  if ('${bannerModel.type}'.toUpperCase() == 'USER') {
    showLoading();
    ProductDetailsController productDetailsController =
        Get.put(ProductDetailsController(), tag: bannerModel.entityId ?? "");
    productDetailsController.getUserByUId(userId: bannerModel.entityId ?? "").then((_) {
      Get.back();
      if (productDetailsController.postUserModel.value?.id == null) {
        CustomSnackBar.showCustomToast(message: localLanguage.user_not_found);
      } else {
        Get.to(
          () => ClientProfileView(
            userId: bannerModel.entityId ?? "",
            productDetailsController: productDetailsController,
          ),
          transition: Transition.fadeIn,
        );
      }
    });
  }
  // IF CATEGORY
  if ('${bannerModel.type}'.toUpperCase() == 'CATEGORY') {
    filterController.isFilterLoading.value = true;
    filterController.filterMapPassed = {
      "category":
          (homeController.categories.firstWhereOrNull((element) => element.sId == bannerModel.entityId)?.name ?? '')
              .toLowerCase(),
      "category_id":
          (homeController.categories.firstWhereOrNull((element) => element.sId == bannerModel.entityId)?.sId ?? '')
              .toLowerCase(),
    };
    filterController.applyFilter();
    filterController.clearAddress();

    Get.to(
      const FilterResultsView(),
      transition: Transition.rightToLeft,
    );
  }
}

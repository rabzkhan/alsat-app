import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/app_home/models/banner_res.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../components/home_segmented.dart';
import '../../../components/network_image_preview.dart';
import '../../../components/product_list_tile.dart';
import '../../product/model/product_post_list_res.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final HomeController homeController = Get.find();
    return Column(
      children: [
        const HomeSegmented(),
        Expanded(
          child: Obx(
            () {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  waterDropColor: context.theme.primaryColor,
                ),
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
                        top: 0.h,
                      ),
                      child: Skeletonizer(
                        enabled: homeController.isBannerLoading.value,
                        effect: ShimmerEffect(
                          baseColor: Get.theme.disabledColor.withOpacity(.2),
                          highlightColor: Colors.white,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        child: CarouselSlider(
                            options: CarouselOptions(
                              height: 160.h, aspectRatio: 16 / 9,
                              viewportFraction: 0.7,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,

                              // onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: List.generate(
                              homeController.isBannerLoading.value
                                  ? 5
                                  : homeController.mainBanner.length,
                              (index) => NewworkImagePreview(
                                radius: 10.r,
                                url: homeController.isBannerLoading.value
                                    ? ''
                                    : homeController
                                            .mainBanner[index].picture ??
                                        '',
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    ),

                    /// other banner
                    Skeletonizer(
                      enabled: homeController.isBannerLoading.value,
                      effect: ShimmerEffect(
                        baseColor: Get.theme.disabledColor.withOpacity(.2),
                        highlightColor: Colors.white,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: homeController.isBannerLoading.value
                            ? 2
                            : homeController.otherBanner.take(2).length,
                        itemBuilder: (context, index) {
                          return NewworkImagePreview(
                            url: homeController.isBannerLoading.value
                                ? ''
                                : homeController.otherBanner[index].picture ??
                                    '',
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    //-- home Product ---//
                    ListView.builder(
                      itemCount: productController.isFetchProduct.value
                          ? 10
                          : productController.productList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ProductModel? productModel =
                            productController.isFetchProduct.value
                                ? null
                                : productController.productList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                          ),
                          child: Skeletonizer(
                            enabled: productController.isFetchProduct.value,
                            effect: ShimmerEffect(
                              baseColor:
                                  Get.theme.disabledColor.withOpacity(.2),
                              highlightColor: Colors.white,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            child: ProductListTile(
                              productModel: productModel,
                            ),
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

  // Column _demoData(BannerModel? bannerModel) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       4.verticalSpace,
  //       Text(
  //         textAlign: TextAlign.left,
  //         bannerModel."The Best Platform for Car Rental",
  //         style: regular.copyWith(
  //           fontSize: 18.sp,
  //           color: Get.theme.appBarTheme.backgroundColor,
  //         ),
  //       ),
  //       10.verticalSpace,
  //       Padding(
  //         padding: EdgeInsets.only(right: 50.w),
  //         child: Text(
  //           textAlign: TextAlign.left,
  //           "Ease of doing a car rental safely and reliably. Of course at a low price.",
  //           style: regular.copyWith(
  //             fontSize: 14.sp,
  //             color: Get.theme.appBarTheme.backgroundColor,
  //           ),
  //         ),
  //       ),
  //       10.verticalSpace,
  //       Expanded(
  //         child: Row(
  //           children: [
  //             InkWell(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xff3563E9),
  //                   borderRadius: BorderRadius.circular(10.r),
  //                 ),
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 20.w,
  //                   vertical: 13.h,
  //                 ),
  //                 child: Text(
  //                   "Rental Car",
  //                   style: regular.copyWith(
  //                     fontSize: 14.sp,
  //                     color: Get.theme.appBarTheme.backgroundColor,
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {},
  //             ),
  //             Expanded(
  //               child: Image.asset(carImage),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }
}

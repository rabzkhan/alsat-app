import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/product_grid_tile.dart';
import '../widget/rate_bottom_sheet.dart';

class ClientProfileView extends StatefulWidget {
  final String userId;
  final ProductDetailsController productDetailsController;
  const ClientProfileView(
      {super.key,
      required this.userId,
      required this.productDetailsController});

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  @override
  void initState() {
    if (widget.productDetailsController.userProductList.isEmpty) {
      widget.productDetailsController.fetchUserProducts();
    }
    super.initState();
  }

  //--- Get All PRODUCT ---//
  RefreshController userProductRefreshController =
      RefreshController(initialRefresh: false);
  void userProductRefresh() async {
    await widget.productDetailsController.fetchUserProducts();
    userProductRefreshController.refreshCompleted();
  }

  void userProductLoading() async {
    if (widget.productDetailsController.userProductPostListRes?.hasMore ??
        false) {
      await widget.productDetailsController.fetchUserProducts(
          nextPaginateDate: widget
              .productDetailsController.userProductList.value.last.createdAt);
    }
    userProductRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            isShowBackButton: true,
            isShowFilter: false,
            isShowSearch: false,
          ),
          // user information
          Obx(() {
            return Skeletonizer(
              enabled: widget.productDetailsController.isFetchUserLoading.value,
              effect: ShimmerEffect(
                baseColor: Get.theme.disabledColor.withOpacity(.2),
                highlightColor: Colors.white,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          child: NewworkImagePreview(
                            radius: 26.r,
                            url: widget.productDetailsController.postUserModel
                                    .value?.picture ??
                                '',
                            height: 52.h,
                            width: 52.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.productDetailsController.postUserModel.value?.userName}',
                                style: regular.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              3.verticalSpace,
                              if ('${widget.productDetailsController.postUserModel.value?.email}'
                                  .isNotEmpty)
                                Text(
                                  '${widget.productDetailsController.postUserModel.value?.email}',
                                  style: regular.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                ),
                              3.verticalSpace,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBarIndicator(
                                    rating: (widget.productDetailsController
                                                .postUserModel.value?.rating ??
                                            0)
                                        .toDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 13.r,
                                    direction: Axis.horizontal,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    '(${widget.productDetailsController.postUserModel.value?.rating ?? 0})',
                                    style: regular.copyWith(
                                      fontSize: 8.sp,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.productDetailsController.postUserModel.value?.followers ?? 0}',
                              style: regular.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              'Followers',
                              style: regular.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        10.horizontalSpace,
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text(
                        //       '120',
                        //       style: regular.copyWith(
                        //         fontSize: 14.sp,
                        //       ),
                        //     ),
                        //     Text(
                        //       'Following',
                        //       style: regular.copyWith(
                        //         fontSize: 13.sp,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    //-- Follow and chat buttons--//
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return Skeletonizer(
                              enabled: widget.productDetailsController
                                  .isFetchUserLoading.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.productDetailsController
                                      .isFetchUserLoading.value = true;
                                  widget.productDetailsController
                                      .followingAUser(
                                    userId: widget.productDetailsController
                                            .postUserModel.value?.id ??
                                        '',
                                    isFollow: !(widget.productDetailsController
                                            .postUserModel.value?.followed ??
                                        false),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: (widget
                                              .productDetailsController
                                              .postUserModel
                                              .value
                                              ?.followed ??
                                          false)
                                      ? context.theme.disabledColor
                                          .withOpacity(.5)
                                      : Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  (widget.productDetailsController.postUserModel
                                              .value?.followed ??
                                          false)
                                      ? 'UnFollow'
                                      : 'Follow',
                                  style: regular.copyWith(
                                    color: Get.theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Message',
                              style: regular.copyWith(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        InkWell(
                          onTap: () {
                            showRateBottomSheet(
                                context, widget.productDetailsController);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Get.theme.primaryColor, // Set border color
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              child: Icon(
                                Icons.star_border_outlined,
                                color: Colors.amber,
                                size: 25.r,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    10.verticalSpace,
                  ],
                ),
              ),
            );
          }),
          Expanded(
            child: Obx(
              () {
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    waterDropColor: context.theme.primaryColor,
                  ),
                  controller: userProductRefreshController,
                  onRefresh: userProductRefresh,
                  onLoading: userProductLoading,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      mainAxisExtent: 200.h,
                    ),
                    itemBuilder: (context, index) {
                      return ProductGridTile(
                        loading: widget
                            .productDetailsController.isFetchUserProduct.value,
                        productModel: widget.productDetailsController
                                .isFetchUserProduct.value
                            ? null
                            : widget.productDetailsController
                                .userProductList[index],
                      );
                    },
                    itemCount:
                        widget.productDetailsController.isFetchUserProduct.value
                            ? 10
                            : widget.productDetailsController.userProductList
                                .length,
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}

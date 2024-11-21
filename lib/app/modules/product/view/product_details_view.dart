// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pod_player/pod_player.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_appbar.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/app/modules/product/view/client_profile_view.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:video_player/video_player.dart';

import '../../../components/network_image_preview.dart';
import '../controller/product_details_controller.dart';
import '../model/product_post_list_res.dart';
import 'product_comments_view.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel? productModel;
  const ProductDetailsView({super.key, this.productModel});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductController productController = Get.find();
  late ProductDetailsController productDetailsController;

  @override
  void initState() {
    productDetailsController =
        Get.put(ProductDetailsController(), tag: widget.productModel?.id);
    initMethod();
    super.initState();
  }

  initMethod() async {
    productDetailsController.productLikeCount(
        productId: widget.productModel?.id ?? '');
    productDetailsController
        .getSingleProductDetails(widget.productModel?.id ?? '');
    productDetailsController.productViewCountAdding(
        productId: widget.productModel?.id ?? '');
    productDetailsController.productViewCount(
        productId: widget.productModel?.id ?? '',
        productCreateTime: widget.productModel?.createdAt ?? '');
    productDetailsController.productCommentCount(
        productId: widget.productModel?.id ?? '');
    productDetailsController.getUserByUId(
        userId: widget.productModel?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              isShowBackButton: true,
              isShowFilter: false,
              isShowSearch: false,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  productDetailsController.productLikeCount(
                      productId: widget.productModel?.id ?? '');
                  productDetailsController.productViewCount(
                      productId: widget.productModel?.id ?? '',
                      productCreateTime: widget.productModel?.createdAt ?? '');
                  productDetailsController.productCommentCount(
                      productId: widget.productModel?.id ?? '');
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  children: [
                    //product Image
                    SizedBox(
                      height: 200.h,
                      width: Get.width,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          widget.productModel?.media?.firstOrNull?.name != null
                              ? CarouselSlider(
                                  items: (widget.productModel?.media ?? [])
                                      .map(
                                        (e) => ProductMediaWidget(e: e),
                                      )
                                      .toList(),
                                  options: CarouselOptions(
                                    height: 400.h,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    scrollDirection: Axis.horizontal,
                                  ))
                              : Image.asset(
                                  'assets/images/car_demo2.png',
                                  fit: BoxFit.fill,
                                  width: Get.width,
                                ),
                          Obx(() {
                            return Skeletonizer(
                              enabled: productDetailsController
                                  .isProductDetailsLoading.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 8.h,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          shareIcon,
                                          height: 30.h,
                                        ),
                                        8.horizontalSpace,
                                        InkWell(
                                          onTap: () async {
                                            await productController
                                                .addProductLike(
                                              productId:
                                                  widget.productModel?.id ?? '',
                                              likeValue:
                                                  !(productDetailsController
                                                          .selectPostProductModel
                                                          .value
                                                          ?.liked ??
                                                      false),
                                            )
                                                .then((_) {
                                              productDetailsController
                                                  .getSingleProductDetails(
                                                      widget.productModel?.id ??
                                                          '');
                                            });
                                          },
                                          child: Obx(() {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                                vertical: 5.h,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (productDetailsController
                                                            .selectPostProductModel
                                                            .value
                                                            ?.liked ??
                                                        false)
                                                    ? Colors.red
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: (productDetailsController
                                                              .selectPostProductModel
                                                              .value
                                                              ?.liked ??
                                                          false)
                                                      ? Colors.red
                                                      : Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              child: productController
                                                          .isProductLike
                                                          .value &&
                                                      productController
                                                              .productLikeId
                                                              .value ==
                                                          (widget.productModel
                                                                  ?.id ??
                                                              '')
                                                  ? const CupertinoActivityIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      (productDetailsController
                                                                  .selectPostProductModel
                                                                  .value
                                                                  ?.liked ??
                                                              false)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: (productDetailsController
                                                                  .selectPostProductModel
                                                                  .value
                                                                  ?.liked ??
                                                              false)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      size: 20.r,
                                                    ),
                                            );
                                          }),
                                        ),
                                        8.horizontalSpace,
                                        // Image.asset(
                                        //   moreIcon,
                                        //   height: 20.h,
                                        // ),
                                        // 30.horizontalSpace,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    //price and name
                    8.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productModel?.title ??
                                    'Hyundai Santa Fe',
                                style: semiBold.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              6.verticalSpace,
                              Text(
                                "\$${widget.productModel?.priceInfo?.price ?? 96.00}  ",
                                style: semiBold.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              // padding: EdgeInsets.all(value),
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                                width: 1.5,
                              ),
                              backgroundColor:
                                  Get.theme.primaryColor.withOpacity(.1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              )),
                          onPressed: () {},
                          label: Text(
                            widget.productModel?.createdAt != null
                                ? timeAgo(DateTime.parse(
                                    widget.productModel?.createdAt ?? ''))
                                : '0 Days Ago',
                            style: regular.copyWith(
                              fontSize: 12.sp,
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          icon: Icon(
                            Icons.calendar_month,
                            size: 20.r,
                            color: Get.theme.primaryColor,
                          ),
                        )
                      ],
                    ),
                    10.verticalSpace,
                    //  information
                    Text(
                      'Information',
                      style: bold.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                        padding: REdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Get.theme.disabledColor.withOpacity(.06),
                          ),
                          color: Get.theme.disabledColor.withOpacity(.03),
                        ),
                        child: widget.productModel?.carInfo != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  infoTile(
                                      name: 'Brand',
                                      value:
                                          widget.productModel?.carInfo?.brand ??
                                              ''),
                                  infoTile(
                                      name: 'Model Type',
                                      value:
                                          widget.productModel?.carInfo?.model ??
                                              ''),
                                  infoTile(
                                      name: 'Body Type',
                                      value: widget.productModel?.carInfo
                                              ?.bodyType ??
                                          ''),
                                  infoTile(
                                      name: 'Year',
                                      value:
                                          "${widget.productModel?.carInfo?.year ?? ''}"),
                                  infoTile(
                                      name: 'Engine',
                                      value: widget.productModel?.carInfo
                                              ?.engineType ??
                                          ''),
                                  infoTile(
                                      name: 'Color',
                                      value:
                                          widget.productModel?.carInfo?.color ??
                                              ''),
                                  infoTile(
                                      name: 'Condition',
                                      value: widget.productModel?.carInfo
                                              ?.condition ??
                                          ''),
                                  infoTile(
                                      name: 'Passed  KM',
                                      value:
                                          "${widget.productModel?.carInfo?.passedKm ?? ''}"),
                                ],
                              )
                            : widget.productModel?.estateInfo != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      infoTile(
                                          name: 'Address',
                                          value: widget.productModel?.estateInfo
                                                  ?.address ??
                                              ''),
                                      infoTile(
                                          name: 'Type',
                                          value: widget.productModel?.estateInfo
                                                  ?.type ??
                                              ''),
                                      infoTile(
                                          name: 'Floor',
                                          value:
                                              "${widget.productModel?.estateInfo?.floor ?? ''}"),
                                      infoTile(
                                          name: 'Floor Type',
                                          value:
                                              "${widget.productModel?.estateInfo?.floorType ?? ''}"),
                                      infoTile(
                                          name: 'Rooom',
                                          value:
                                              "${widget.productModel?.estateInfo?.room ?? ''}"),
                                      infoTile(
                                          name: 'Lift',
                                          value: (widget.productModel
                                                      ?.estateInfo?.lift ??
                                                  false)
                                              ? 'Avalable'
                                              : 'No'),
                                    ],
                                  )
                                : widget.productModel?.phoneInfo != null
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          infoTile(
                                              name: 'Brand',
                                              value: widget.productModel
                                                      ?.phoneInfo?.brand ??
                                                  ''),
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          infoTile(
                                              name: 'Location',
                                              value: widget
                                                      .productModel
                                                      ?.individualInfo
                                                      ?.locationCity ??
                                                  ''),
                                        ],
                                      )),
                    20.verticalSpace,
                    //  discription
                    Text(
                      'Discription',
                      style: bold.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      textAlign: TextAlign.justify,
                      widget.productModel?.description ??
                          'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ',
                      style: regular.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        children: [
                          Image.asset(
                            eyeIcon,
                            width: 25.w,
                          ),
                          5.horizontalSpace,
                          Obx(() {
                            return Skeletonizer(
                              enabled:
                                  productDetailsController.isProductView.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'views',
                                    style: regular.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    '${productDetailsController.viewCount.value}',
                                    style: regular.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          10.horizontalSpace,
                          Container(
                            color: Get.theme.disabledColor,
                            width: 1.w,
                            height: 15.h,
                          ),
                          10.horizontalSpace,
                          Image.asset(
                            heartIcon,
                            width: 25.w,
                          ),
                          5.horizontalSpace,
                          Obx(() {
                            return Skeletonizer(
                              enabled:
                                  productDetailsController.isProductLike.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Like',
                                    style: regular.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    '${productDetailsController.likeCount}',
                                    style: regular.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          10.horizontalSpace,
                          Container(
                            color: Get.theme.disabledColor,
                            width: 1.w,
                            height: 15.h,
                          ),
                          10.horizontalSpace,
                          Image.asset(
                            messageIcon,
                            width: 25.w,
                          ),
                          5.horizontalSpace,
                          Obx(() {
                            return Skeletonizer(
                              enabled: productDetailsController
                                  .isProductComment.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ProductCommentsView(
                                      productDetailsController:
                                          productDetailsController,
                                      productModel: widget.productModel!,
                                    ),
                                    transition: Transition.fadeIn,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'comment',
                                      style: regular.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      '${productDetailsController.commentCount}',
                                      style: regular.copyWith(
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    ///user information
                    Obx(() {
                      return Skeletonizer(
                        enabled:
                            productDetailsController.isFetchUserLoading.value,
                        effect: ShimmerEffect(
                          baseColor: Get.theme.disabledColor.withOpacity(.2),
                          highlightColor: Colors.white,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(
                              () => ClientProfileView(
                                userId: (
                                  productDetailsController
                                      .postUserModel.value?.id,
                                ).toString(),
                                productDetailsController:
                                    productDetailsController,
                              ),
                              transition: Transition.fadeIn,
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 22.r,
                            child: NewworkImagePreview(
                              radius: 22.r,
                              url: productDetailsController
                                      .postUserModel.value?.picture ??
                                  '',
                              height: 44.h,
                              width: 44.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            productDetailsController
                                    .postUserModel.value?.userName ??
                                'John Coltrane',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          subtitle: Text(
                            (productDetailsController
                                            .postUserModel.value?.email ??
                                        '')
                                    .isEmpty
                                ? productDetailsController
                                        .postUserModel.value?.phone ??
                                    'info@gmail.com'
                                : productDetailsController
                                        .postUserModel.value?.email ??
                                    '',
                            style: regular.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    }),
                    5.verticalSpace,
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: IgnorePointer(
                        ignoring: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: GoogleMap(
                            mapToolbarEnabled: false,
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  widget.productModel?.individualInfo
                                          ?.locationGeo?.coordinates?.last ??
                                      0,
                                  widget.productModel?.individualInfo
                                          ?.locationGeo?.coordinates?.first ??
                                      0),
                              zoom: 14.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {},
                          ),
                        ),
                      ),
                    ),
                    // more product
                    // Text(
                    //   'More Items From Saravanan B',
                    //   style: semiBold.copyWith(
                    //     fontSize: 14.sp,
                    //   ),
                    // ),
                    10.verticalSpace,
                    // SizedBox(
                    //   height: 200.h,
                    //   child: ListView.separated(
                    //     separatorBuilder: (context, index) =>
                    //         10.horizontalSpace,
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: 6,
                    //     itemBuilder: (context, index) => SizedBox(
                    //         width: (Get.width * .5) - 20.w,
                    //         child: const ProductGridTile()),
                    //   ),
                    // ),
                    // 20.verticalSpace,
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 2,
                    //       child: MaterialButton(
                    //         padding: EdgeInsets.symmetric(
                    //           vertical: 14.h,
                    //           horizontal: 20.w,
                    //         ),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8.r),
                    //           side: BorderSide(
                    //             color: Theme.of(context).primaryColor,
                    //           ),
                    //         ),
                    //         onPressed: () {
                    //           Get.to(const ProductInsightsView(),
                    //               transition: Transition.fadeIn);
                    //         },
                    //         child: Text(
                    //           'Insights',
                    //           style: regular.copyWith(
                    //             color: Theme.of(context).primaryColor,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     10.horizontalSpace,
                    //     Expanded(
                    //       flex: 3,
                    //       child: MaterialButton(
                    //         padding: EdgeInsets.symmetric(
                    //           vertical: 14.h,
                    //           horizontal: 20.w,
                    //         ),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8.r),
                    //         ),
                    //         elevation: 0,
                    //         color: Theme.of(context).primaryColor,
                    //         onPressed: () {},
                    //         child: Text(
                    //           'Boost Your Ad',
                    //           style: regular.copyWith(
                    //             color: Get.theme.scaffoldBackgroundColor,
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductMediaWidget extends StatefulWidget {
  final Media e;
  const ProductMediaWidget({
    super.key,
    required this.e,
  });

  @override
  State<ProductMediaWidget> createState() => _ProductMediaWidgetState();
}

class _ProductMediaWidgetState extends State<ProductMediaWidget> {
  late VideoPlayerController videoPlayerController;
  late final PodPlayerController controller;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    if ((widget.e.contentType ?? '').toLowerCase().contains('video')) {
      controller = PodPlayerController(
          playVideoFrom: PlayVideoFrom.network(
            widget.e.name ?? '',
          ),
          podPlayerConfig: const PodPlayerConfig(
            autoPlay: false,
            isLooping: false,
          ))
        ..initialise().catchError((onError) {
          log('videoError: $onError');
        });
    }
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.e.contentType ?? '').toLowerCase().contains('image')
        ? NewworkImagePreview(
            radius: 10.r,
            url: widget.e.name ?? '',
            height: 90.h,
            width: Get.width,
            fit: BoxFit.cover,
          )
        : (widget.e.contentType ?? '').toLowerCase().contains('video')
            ? PodVideoPlayer(
                controller: controller,
                onLoading: (context) => const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              )
            : const CupertinoActivityIndicator();
  }
}

Padding infoTile({required String name, required String value}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        Text(
          name,
          style: regular.copyWith(
            fontSize: 13.sp,
            color: Get.theme.disabledColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: regular.copyWith(
            fontSize: 13.sp,
          ),
        ),
      ],
    ),
  );
}

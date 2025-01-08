// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:url_launcher/url_launcher.dart';
import '../../../components/network_image_preview.dart';
import '../../conversation/view/message_view.dart';
import '../controller/product_details_controller.dart';
import '../model/product_post_list_res.dart';
import '../widget/product_media.dart';
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
    Future.delayed(Duration.zero, () {
      if (widget.productModel?.id == null) {
        Get.back();
        CustomSnackBar.showCustomToast(message: 'Product Not Found');
      }
    });
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: BackButton(
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
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
          padding: EdgeInsets.zero,
          children: [
            //product Image
            SizedBox(
              height: 250.h,
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
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.1,
                            scrollDirection: Axis.horizontal,
                          ))
                      : Image.asset(
                          'assets/images/car_demo2.png',
                          fit: BoxFit.fill,
                          width: Get.width,
                        ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //price and name
                  8.verticalSpace,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.all(value),
                        side: BorderSide(
                          color: Get.theme.primaryColor,
                          width: .5,
                        ),
                        backgroundColor: Get.theme.primaryColor.withOpacity(.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
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
                  ),

                  2.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel?.title ?? 'Hyundai Santa Fe',
                              style: semiBold.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            6.verticalSpace,
                            Text(
                              "\$${widget.productModel?.priceInfo?.price ?? 0.00}  ",
                              style: semiBold.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(5.r),
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
                                    value: widget
                                            .productModel?.carInfo?.bodyType ??
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
                                    value: widget
                                            .productModel?.carInfo?.condition ??
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
                                        value: (widget.productModel?.estateInfo
                                                    ?.lift ??
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
                    widget.productModel?.description ?? '',
                    style: regular.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w)
                            .copyWith(right: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Get.theme.disabledColor.withOpacity(.03),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Obx(() {
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    eyeIcon,
                                    width: 25.w,
                                  ),
                                  5.horizontalSpace,
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Views',
                                        style: regular.copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${productDetailsController.viewCount.value}',
                                        style: regular.copyWith(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        8.horizontalSpace,
                        Container(
                          color: Get.theme.disabledColor,
                          width: 1.w,
                          height: 25.h,
                        ),
                        8.horizontalSpace,
                        Expanded(
                          flex: 2,
                          child: Obx(() {
                            return Skeletonizer(
                              enabled: productDetailsController
                                      .isProductLike.value ||
                                  productDetailsController
                                      .isProductDetailsLoading.value,
                              effect: ShimmerEffect(
                                baseColor:
                                    Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: InkWell(
                                onTap: () {
                                  productController
                                      .addProductLike(
                                    productId: widget.productModel?.id ?? '',
                                    likeValue: !(productDetailsController
                                            .selectPostProductModel
                                            .value
                                            ?.liked ??
                                        false),
                                  )
                                      .then((_) {
                                    productDetailsController
                                        .getSingleProductDetails(
                                            widget.productModel?.id ?? '');
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    productController.isProductLike.value &&
                                            productController
                                                    .productLikeId.value ==
                                                (widget.productModel?.id ?? '')
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
                                                : Icons.favorite_border,
                                            color: (productDetailsController
                                                        .selectPostProductModel
                                                        .value
                                                        ?.liked ??
                                                    false)
                                                ? Colors.red
                                                : Colors.black,
                                            size: 26.r,
                                          ),
                                    6.horizontalSpace,
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Like',
                                          style: regular.copyWith(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${productDetailsController.likeCount}',
                                          style: regular.copyWith(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        8.horizontalSpace,
                        Container(
                          color: Get.theme.disabledColor,
                          width: 1.w,
                          height: 25.h,
                        ),
                        8.horizontalSpace,
                        Expanded(
                          flex: 3,
                          child: Obx(() {
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
                              child: InkWell(
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      messageIcon,
                                      width: 25.w,
                                    ),
                                    5.horizontalSpace,
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Comment',
                                          style: regular.copyWith(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${productDetailsController.commentCount}',
                                          style: regular.copyWith(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        8.horizontalSpace,
                        Container(
                          color: Get.theme.disabledColor,
                          width: 1.w,
                          height: 25.h,
                        ),
                        8.horizontalSpace,
                        //--share Button---
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                                size: 22.r,
                              ),
                              4.horizontalSpace,
                              Text(
                                'Share',
                                style: regular.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              userId: productDetailsController
                                      .postUserModel.value?.id ??
                                  "".toString(),
                              productDetailsController:
                                  productDetailsController,
                            ),
                            transition: Transition.fadeIn,
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 22.r,
                          child: NetworkImagePreview(
                            radius: 22.r,
                            url: productDetailsController
                                    .postUserModel.value?.picture ??
                                '',
                            height: 44.h,
                            width: 44.w,
                            fit: BoxFit.cover,
                            error: Image.asset(userDefaulticon),
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
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBarIndicator(
                              rating: (productDetailsController
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
                            3.horizontalSpace,
                            Text(
                              '(${(productDetailsController.postUserModel.value?.rating ?? 0).toStringAsFixed(1)})',
                              style: regular.copyWith(
                                fontSize: 8.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),

                  12.verticalSpace,
                  Text(
                    'Contact With Seller',
                    style: semiBold.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  10.verticalSpace,

                  Row(
                    children: [
                      if (isCallAvailable(
                          widget.productModel?.individualInfo?.freeToCallFrom,
                          widget.productModel?.individualInfo?.freeToCallTo))
                        Expanded(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            height: 45,
                            color: Get.theme.scaffoldBackgroundColor,
                            onPressed: () async {
                              final url =
                                  'tel:${widget.productModel?.individualInfo?.phoneNumber}';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Get.theme.primaryColor,
                                  size: 20.r,
                                ),
                                5.horizontalSpace,
                                Text(
                                  'Call ',
                                  style: regular.copyWith(
                                    color: Get.theme.primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isCallAvailable(
                          widget.productModel?.individualInfo?.freeToCallFrom,
                          widget.productModel?.individualInfo?.freeToCallTo))
                        30.horizontalSpace,
                      Expanded(
                        child: Obx(() {
                          return MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            height: 45,
                            color: Get.theme.primaryColor,
                            onPressed: productDetailsController
                                    .isFetchUserConversationLoading.value
                                ? null
                                : () {
                                    productDetailsController
                                        .getConversationInfoByUserId(
                                            productDetailsController
                                                    .postUserModel.value?.id ??
                                                "")
                                        .then((value) {
                                      Get.to(
                                        MessagesScreen(
                                          conversation: productDetailsController
                                              .conversationInfo.value!,
                                        ),
                                        transition: Transition.fadeIn,
                                      );
                                    });
                                  },
                            child: productDetailsController
                                    .isFetchUserConversationLoading.value
                                ? const CupertinoActivityIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.messenger_rounded,
                                        color: Colors.white,
                                        size: 20.r,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        'Mesaage',
                                        style: regular.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        }),
                      ),
                    ],
                  )
                ],
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
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
            fontSize: 15.sp,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: regular.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

bool isCallAvailable(String? freeFrom, String? freeTo) {
  bool isAvailable = false;
  if (freeFrom == null || freeTo == null) return false;
  List<String> fromParts = freeFrom.split(":");
  List<String> toParts = freeTo.split(":");

  int fromHour = int.tryParse(fromParts[0]) ?? 0;
  int fromMinute = int.tryParse(fromParts[1]) ?? 0;

  int toHour = int.tryParse(toParts[0]) ?? 0;
  int toMinute = int.tryParse(toParts[1]) ?? 0;
  DateTime now = DateTime.now();
  int currentHour = now.hour;
  int currentMinute = now.minute;
  int fromTimeInMinutes = fromHour * 60 + fromMinute;
  int toTimeInMinutes = toHour * 60 + toMinute;
  int currentTimeInMinutes = currentHour * 60 + currentMinute;
  if (fromTimeInMinutes <= currentTimeInMinutes &&
      currentTimeInMinutes <= toTimeInMinutes) {
    isAvailable = true;
  } else {
    isAvailable = false;
  }
  log('freeFrom: $freeFrom freeTo $freeTo ==  $isAvailable');
  return isAvailable;
}

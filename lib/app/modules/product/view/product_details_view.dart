// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'dart:developer';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/view/update_post_view.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/translations/localization_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/app/modules/product/view/client_profile_view.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/translations.dart';
import '../../../components/formate_datetime.dart';
import '../../../components/network_image_preview.dart';
import '../../conversation/view/message_view.dart';
import '../controller/product_details_controller.dart';
import '../model/product_post_list_res.dart';
import '../widget/product_media.dart';
import 'product_comments_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel? productModel;
  final bool isFromMessage;
  const ProductDetailsView({super.key, this.productModel, this.isFromMessage = false});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductController productController = Get.find();
  late ProductDetailsController productDetailsController;
  AuthController authController = Get.find();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.productModel?.id == null) {
        Get.back();
        final localLanguage = AppLocalizations.of(Get.context!)!;
        CustomSnackBar.showCustomToast(message: localLanguage.some_thing_went_worng);
      }
    });
    productDetailsController = Get.put(ProductDetailsController(), tag: widget.productModel?.id);
    initMethod();
    super.initState();
  }

  initMethod() async {
    productDetailsController.productLikeCount(productId: widget.productModel?.id ?? '');
    productDetailsController.getSingleProductDetails(widget.productModel?.id ?? '');
    productDetailsController.productViewCountAdding(productId: widget.productModel?.id ?? '');
    productDetailsController.productViewCount(
        productId: widget.productModel?.id ?? '', productCreateTime: widget.productModel?.createdAt ?? '');
    productDetailsController.productCommentCount(productId: widget.productModel?.id ?? '');
    productDetailsController.getUserByUId(userId: widget.productModel?.userId ?? '').then((value) {
      if (authController.userDataModel.value.id == productDetailsController.postUserModel.value?.id) {
        // productDetailsController.getProductInsights(pId: widget.productModel?.id ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
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
          productDetailsController.productLikeCount(productId: widget.productModel?.id ?? '');
          productDetailsController.productViewCount(
              productId: widget.productModel?.id ?? '', productCreateTime: widget.productModel?.createdAt ?? '');
          productDetailsController.productCommentCount(productId: widget.productModel?.id ?? '');
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
                          carouselController: productDetailsController.carouselSliderController,
                          items: (widget.productModel?.media ?? [])
                              .map(
                                (e) => ProductMediaWidget(
                                  e: e,
                                  galleryItems: (widget.productModel?.media ?? []),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              productDetailsController.carouselCurrentIndex.value = index;
                            },
                            height: 400.h,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                  // Positioned(
                  //   right: 10.w,
                  //   bottom: 10.h,
                  //   child: Obx(() {
                  //     bool haveVideo = ((widget.productModel?.media ?? [])
                  //             .firstWhereOrNull((e) => (e.contentType ?? '').toLowerCase().contains('video')) !=
                  //         null);
                  //     int indexOfVideo = (widget.productModel?.media ?? [])
                  //         .indexWhere((e) => (e.contentType ?? '').toLowerCase().contains('video'));
                  //     return haveVideo && productDetailsController.carouselCurrentIndex.value != indexOfVideo
                  //         ? CircleAvatar(
                  //             backgroundColor: AppColors.primary,
                  //             child: IconButton.filled(
                  //               color: Colors.white,
                  //               onPressed: () {
                  //                 productDetailsController.carouselSliderController.animateToPage(indexOfVideo);
                  //               },
                  //               icon: Icon(Icons.play_arrow),
                  //             ),
                  //           )
                  //         : SizedBox();
                  //   }),
                  // ),
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
                  15.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 25.r,
                        color: Get.theme.primaryColor,
                      ),
                      10.horizontalSpace,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDateTime(
                              widget.productModel?.createdAt ?? '',
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.productModel?.createdAt != null
                                ? timeAgo(DateTime.parse(widget.productModel?.createdAt ?? ''))
                                : '0 Days Ago',
                            style: regular.copyWith(
                              fontSize: 12.sp,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                    ],
                  ),

                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel?.title ?? '',
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
                  7.verticalSpace,

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h).copyWith(bottom: 0),
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w).copyWith(right: 0),
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
                              enabled: productDetailsController.isProductView.value,
                              effect: ShimmerEffect(
                                baseColor: Get.theme.disabledColor.withOpacity(.2),
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
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          localLanguage.views,
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
                              enabled: productDetailsController.isProductLike.value ||
                                  productDetailsController.isProductDetailsLoading.value,
                              effect: ShimmerEffect(
                                baseColor: Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: InkWell(
                                onTap: authController.userDataModel.value.id == null
                                    ? null
                                    : () {
                                        productController
                                            .addProductLike(
                                          productId: widget.productModel?.id ?? '',
                                          likeValue:
                                              !(productDetailsController.selectPostProductModel.value?.liked ?? false),
                                        )
                                            .then((_) {
                                          productDetailsController
                                              .getSingleProductDetails(widget.productModel?.id ?? '');
                                          productDetailsController.productLikeCount(
                                              productId: widget.productModel?.id ?? '');
                                        });
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    productController.isProductLike.value &&
                                            productController.productLikeId.value == (widget.productModel?.id ?? '')
                                        ? const CupertinoActivityIndicator(
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            (productDetailsController.selectPostProductModel.value?.liked ?? false)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                (productDetailsController.selectPostProductModel.value?.liked ?? false)
                                                    ? Colors.red
                                                    : Colors.black,
                                            size: 26.r,
                                          ),
                                    6.horizontalSpace,
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            localLanguage.like,
                                            style: regular.copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Obx(() {
                                            return Text(
                                              '${productDetailsController.likeCount}',
                                              style: regular.copyWith(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
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
                              enabled: productDetailsController.isProductComment.value,
                              effect: ShimmerEffect(
                                baseColor: Get.theme.disabledColor.withOpacity(.2),
                                highlightColor: Colors.white,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    ProductCommentsView(
                                      productDetailsController: productDetailsController,
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
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            localLanguage.comment,
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
                        IconButton(
                          onPressed: () async {
                            final contentToShare =
                                "Check out this amazing deal on ${widget.productModel?.title}! Only at ${widget.productModel?.priceInfo?.price}. Buy now on Alsat: App Link";
                            final box = context.findRenderObject() as RenderBox?;
                            await Share.share(
                              contentToShare,
                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                            );
                          },
                          padding: EdgeInsets.all(10).r,
                          constraints: BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
                          ),
                          iconSize: 18.h,
                          icon: Icon(
                            CupertinoIcons.arrowshape_turn_up_right,
                            size: 18.h,
                          ),
                        ),
                        8.horizontalSpace,
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  // Obx(() {
                  //   return productDetailsController.productInsightsList.isEmpty
                  //       ? const Center()
                  //       : ExpansionTile(
                  //           collapsedBackgroundColor: Get.theme.disabledColor.withOpacity(.03),
                  //           backgroundColor: Get.theme.disabledColor.withOpacity(.03),
                  //           // tilePadding: EdgeInsets.zero,
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide.none,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           collapsedShape: RoundedRectangleBorder(
                  //             side: BorderSide.none,
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           title: Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Image.asset(
                  //                 'assets/icons/sport.png',
                  //                 width: 25.w,
                  //                 height: 25.h,
                  //                 color: Get.theme.primaryColor,
                  //               ),
                  //               8.horizontalSpace,
                  //               const Text('Product Insights'),
                  //             ],
                  //           ),
                  //           children: [
                  //             _viewTile(
                  //               title: 'Province/State',
                  //               value: 'View Count',
                  //             ),
                  //             ...productDetailsController.productInsightsList.map((e) {
                  //               return _viewTile(
                  //                 title: '${e['province'].isEmpty ? 'Unknown' : e['province']}',
                  //                 value: '${e['count']}',
                  //               );
                  //             })
                  //           ],
                  //         );
                  // }),

                  7.verticalSpace,
                  //Location
                  Text(
                    localLanguage.location,
                    style: bold.copyWith(
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  4.verticalSpace,
                  // Row(
                  //   children: [
                  //     Text(
                  //       widget.productModel?.individualInfo?.locationProvince ?? '',
                  //       style: bold.copyWith(
                  //         fontSize: 12.sp,
                  //         fontFamily: 'Poppins',
                  //         color: AppColors.primary,
                  //       ),
                  //     ),
                  //     Text(
                  //       ",${widget.productModel?.individualInfo?.locationCity ?? ''}",
                  //       style: bold.copyWith(
                  //         fontSize: 12.sp,
                  //         fontFamily: 'Poppins',
                  //         color: AppColors.primary,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Text(
                        Get.find<LocalizationController>().translateName(
                            widget.productModel?.individualInfo?.locationProvince ?? '', provinceTranslations),
                        style: bold.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        ', ${Get.find<LocalizationController>().translateName(widget.productModel?.individualInfo?.locationCity ?? '', cityTranslations)}',
                        style: bold.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  //  information
                  Text(
                    localLanguage.information,
                    style: bold.copyWith(
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
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
                                infoTile(name: localLanguage.brand, value: widget.productModel?.carInfo?.brand ?? ''),
                                infoTile(
                                    name: localLanguage.modelType, value: widget.productModel?.carInfo?.model ?? ''),
                                infoTile(
                                    name: localLanguage.bodyType, value: widget.productModel?.carInfo?.bodyType ?? ''),
                                infoTile(
                                    name: localLanguage.year, value: "${widget.productModel?.carInfo?.year ?? ''}"),
                                infoTile(
                                    name: localLanguage.engine, value: widget.productModel?.carInfo?.engineType ?? ''),
                                infoTile(name: localLanguage.color, value: widget.productModel?.carInfo?.color ?? ''),
                                infoTile(
                                    name: localLanguage.vin_code, value: widget.productModel?.carInfo?.vinCode ?? ''),
                              ],
                            )
                          : widget.productModel?.estateInfo != null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    infoTile(
                                        name: localLanguage.address,
                                        value: widget.productModel?.estateInfo?.address ?? ''),
                                    infoTile(
                                        name: localLanguage.type, value: widget.productModel?.estateInfo?.type ?? ''),
                                    infoTile(
                                        name: localLanguage.floor,
                                        value: "${widget.productModel?.estateInfo?.floor ?? ''}"),
                                    infoTile(
                                        name: localLanguage.floorType,
                                        value: "${widget.productModel?.estateInfo?.floorType ?? ''}"),
                                    infoTile(
                                        name: localLanguage.room,
                                        value: "${widget.productModel?.estateInfo?.room ?? ''}"),
                                    infoTile(
                                        name: localLanguage.lift,
                                        value: (widget.productModel?.estateInfo?.lift ?? false)
                                            ? localLanguage.available
                                            : localLanguage.no),
                                  ],
                                )
                              : widget.productModel?.phoneInfo != null
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        infoTile(
                                            name: localLanguage.brand,
                                            value: widget.productModel?.phoneInfo?.brand ?? ''),
                                      ],
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        infoTile(
                                            name: localLanguage.location,
                                            value: widget.productModel?.individualInfo?.locationCity ?? ''),
                                      ],
                                    )),
                  20.verticalSpace,
                  //  discription
                  Text(
                    localLanguage.description,
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

                  ///user information
                  Obx(() {
                    return Skeletonizer(
                      enabled: productDetailsController.isFetchUserLoading.value,
                      child: ListTile(
                        onTap: () {
                          Get.to(
                            () => ClientProfileView(
                              isFromMessage: widget.isFromMessage,
                              userId: productDetailsController.postUserModel.value?.id ?? "".toString(),
                              productDetailsController: productDetailsController,
                            ),
                            transition: Transition.fadeIn,
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 22.r,
                          child: NetworkImagePreview(
                            radius: 22.r,
                            url: productDetailsController.postUserModel.value?.picture ?? '',
                            height: 44.h,
                            width: 44.w,
                            fit: BoxFit.cover,
                            error: Image.asset(userDefaultIcon),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              productDetailsController.postUserModel.value?.userName ?? 'John Coltrane',
                              style: bold.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            6.horizontalSpace,
                            if (productDetailsController.postUserModel.value?.premium ?? false)
                              Icon(
                                Icons.verified,
                                size: 18.r,
                                color: Get.theme.primaryColor,
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBarIndicator(
                                  rating: (productDetailsController.postUserModel.value?.rating ?? 0).toDouble(),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14.r,
                                  color: (productDetailsController.postUserModel.value?.protectionLabel ?? false)
                                      ? Colors.green
                                      : Get.theme.disabledColor.withOpacity(.1),
                                ),
                                3.horizontalSpace,
                                Text(
                                  localLanguage.buyer_protection,
                                  style: (productDetailsController.postUserModel.value?.protectionLabel ?? false)
                                      ? regular.copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        )
                                      : regular.copyWith(
                                          fontSize: 12.sp,
                                          color: Get.theme.disabledColor.withOpacity(0.2),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () {
          return authController.userDataModel.value.id == null
              ? SizedBox()
              : (productDetailsController.postUserModel.value?.id ?? "") == authController.userDataModel.value.id ||
                      productDetailsController.postUserModel.value == null
                  ? (authController.userDataModel.value.id == productDetailsController.postUserModel.value?.id)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  return MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    height: 45,
                                    color: Get.theme.disabledColor,
                                    onPressed: productDetailsController.isDeletingPost.value
                                        ? null
                                        : () {
                                            productDetailsController.deleteUserPost(
                                              postId: widget.productModel?.id ?? '',
                                            );
                                          },
                                    child: productDetailsController.isDeletingPost.value
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CupertinoActivityIndicator(),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 22.sp,
                                                color: Colors.white,
                                              ),
                                              5.horizontalSpace,
                                              Text(
                                                localLanguage.delete,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                }),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  height: 45,
                                  color: Get.theme.primaryColor,
                                  onPressed: () {
                                    Get.off(() => UpdatePostView(productModel: widget.productModel!));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 22.sp,
                                        color: Colors.white,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        localLanguage.edit,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                        )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localLanguage.contactWithSeller,
                            style: semiBold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              if (isCallAvailable(widget.productModel?.individualInfo?.freeToCallFrom,
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
                                      final url = 'tel:${widget.productModel?.individualInfo?.phoneNumber}';
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
                                          localLanguage.call,
                                          style: regular.copyWith(
                                            color: Get.theme.primaryColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (isCallAvailable(widget.productModel?.individualInfo?.freeToCallFrom,
                                  widget.productModel?.individualInfo?.freeToCallTo))
                                if (!widget.isFromMessage) 30.horizontalSpace,
                              if (!widget.isFromMessage)
                                Expanded(
                                  child: Obx(() {
                                    return MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      height: 45,
                                      color: Get.theme.primaryColor,
                                      onPressed: productDetailsController.isFetchUserConversationLoading.value ||
                                              widget.isFromMessage
                                          ? null
                                          : () {
                                              productDetailsController
                                                  .getConversationInfoByUserId(
                                                      productDetailsController.postUserModel.value?.id ?? "")
                                                  .then((value) {
                                                Get.to(
                                                  MessagesScreen(
                                                    productModel: widget.productModel,
                                                    conversation: productDetailsController.conversationInfo.value!,
                                                  ),
                                                  transition: Transition.fadeIn,
                                                );
                                              });
                                            },
                                      child: productDetailsController.isFetchUserConversationLoading.value
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
                                                  localLanguage.message,
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
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  Padding _viewTile({required String title, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w).copyWith(top: 0),
      child: Row(
        children: [
          Text(
            title,
            style: regular.copyWith(
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: regular.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Padding infoTile({required String name, required String value}) {
  bool isVin = name.toLowerCase().contains('vin');

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            name,
            style: regular.copyWith(fontSize: 15.sp, fontFamily: 'Exo'),
          ),
        ),
        const SizedBox(width: 8),
        if (isVin)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
            },
            child: Row(
              children: [
                Text(
                  value,
                  style: regular.copyWith(
                    fontSize: 15.sp,
                    fontFamily: 'Exo',
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.copy,
                  size: 16.sp,
                  color: Colors.blue,
                ),
              ],
            ),
          )
        else
          Text(
            value,
            style: regular.copyWith(
              fontSize: 15.sp,
              fontFamily: 'Exo',
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

  int fromHour = int.tryParse(fromParts.elementAtOrNull(0) ?? '') ?? 0;
  int fromMinute = int.tryParse(fromParts.elementAtOrNull(1) ?? '') ?? 0;

  int toHour = int.tryParse(toParts.elementAtOrNull(0) ?? '') ?? 0;
  int toMinute = int.tryParse(toParts.elementAtOrNull(1) ?? '') ?? 0;
  DateTime now = DateTime.now();
  int currentHour = now.hour;
  int currentMinute = now.minute;
  int fromTimeInMinutes = fromHour * 60 + fromMinute;
  int toTimeInMinutes = toHour * 60 + toMinute;
  int currentTimeInMinutes = currentHour * 60 + currentMinute;
  if (fromTimeInMinutes <= currentTimeInMinutes && currentTimeInMinutes <= toTimeInMinutes) {
    isAvailable = true;
  } else {
    isAvailable = false;
  }
  log('freeFrom: $freeFrom freeTo $freeTo ==  $isAvailable');
  return isAvailable;
}

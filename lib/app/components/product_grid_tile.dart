// ignore_for_file: deprecated_member_use

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/product/view/product_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' as animate;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../config/theme/app_text_theme.dart';
import '../modules/product/model/product_post_list_res.dart';

class ProductGridTile extends StatelessWidget {
  final ProductModel? productModel;
  final bool loading;
  final bool isShowFavoriteButton;
  final bool isFromMessage;
  const ProductGridTile(
      {super.key,
      this.productModel,
      required this.loading,
      this.isShowFavoriteButton = false,
      this.isFromMessage = false});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: GestureDetector(
        onTap: () {
          Get.to(
            ProductDetailsView(
              isFromMessage: isFromMessage,
              productModel: productModel,
            ),
            transition: Transition.fadeIn,
            preventDuplicates: false,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
          ),
          decoration: BoxDecoration(
            color: Get.theme.appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              color: Get.theme.disabledColor.withOpacity(0.2),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 10.w,
                    ),
                    child: productModel?.media?.firstOrNull?.name != null
                        ? NetworkImagePreview(
                            fit: BoxFit.cover,
                            radius: 2.r,
                            url: productModel?.media?.firstOrNull?.name ?? '',
                            height: 90.h,
                            width: double.infinity,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              carImage,
                              height: 90.h,
                              width: double.infinity,
                              // fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  2.verticalSpace,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RichText(
                              maxLines: 1,
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      productModel?.title ?? 'No Product Name',
                                  style: bold.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ])),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            productModel?.description ??
                                'There Has No Description',
                            style: regular.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "\$${productModel?.priceInfo?.price ?? 00.00}",
                              style: bold.copyWith(
                                fontSize: 17.sp,
                              ),
                            ),
                          ])),
                          if ((productModel?.carInfo?.brand?.isNotEmpty ??
                                  false) ||
                              (productModel?.phoneInfo?.brand?.isNotEmpty ??
                                  false) ||
                              (productModel?.estateInfo?.address?.isNotEmpty ??
                                  false))
                            Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      (productModel?.priceInfo?.credit ?? false)
                                          ? CupertinoIcons.checkmark_alt
                                          : CupertinoIcons.xmark,
                                      size: 15.r,
                                      color: (productModel?.priceInfo?.credit ??
                                              false)
                                          ? Get.theme.primaryColor
                                          : Colors.red,
                                    ),
                                    3.horizontalSpace,
                                    Text(
                                      'Credit',
                                      style: regular.copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                                5.horizontalSpace,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      (productModel?.priceInfo
                                                  ?.possibleExchange ??
                                              false)
                                          ? CupertinoIcons.checkmark_alt
                                          : CupertinoIcons.xmark,
                                      size: 15.r,
                                      color: (productModel?.priceInfo
                                                  ?.possibleExchange ??
                                              false)
                                          ? Get.theme.primaryColor
                                          : Colors.red,
                                    ),
                                    3.horizontalSpace,
                                    Text(
                                      'exchange',
                                      style: regular.copyWith(
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          5.verticalSpace,
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (isShowFavoriteButton)
                Positioned(
                  right: 10.w,
                  top: 4.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Get.theme.disabledColor.withOpacity(.06),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20.r,
                    ),
                  ),
                )
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }
}

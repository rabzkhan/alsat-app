import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/app/modules/product/view/product_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';
import '../modules/product/model/product_post_list_res.dart';

class ProductListTile extends StatelessWidget {
  final ProductModel? productModel;
  final bool isShowLikeButton;
  const ProductListTile(
      {super.key, this.productModel, this.isShowLikeButton = false});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find();
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsView(productModel: productModel),
            transition: Transition.fadeIn);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 14.w,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        height: 95.h,
        decoration: BoxDecoration(
          color: Get.theme.appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  child: productModel?.media?.firstOrNull?.name != null
                      ? NewworkImagePreview(
                          radius: 10.r,
                          url: productModel?.media?.firstOrNull?.name ?? '',
                          height: 90.h,
                          width: 80.h,
                          fit: BoxFit.cover,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            carImage,
                            height: 90.h,
                            width: 80.h,
                            fit: BoxFit.cover,
                            // fit: BoxFit.cover,
                          ),
                        ),
                ),
                4.horizontalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: productModel?.title ?? 'Hyundai santa fe ',
                            style: regular.copyWith(
                              fontSize: 15.sp,
                            ),
                          ),
                        ])),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          productModel?.description ??
                              'Lorem ipsum is placeholder text  ',
                          style: regular.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\$${productModel?.priceInfo?.price ?? 96.00}  ",
                            style: bold.copyWith(
                              fontSize: 15.sp,
                            ),
                          ),
                          // TextSpan(
                          //   text: ' day',
                          //   style: regular.copyWith(
                          //     fontSize: 11.sp,
                          //     color: Get.theme.disabledColor,
                          //   ),
                          // ),

                          TextSpan(
                            text:
                                '${productModel?.individualInfo?.locationCity} ${(productModel?.individualInfo?.locationCity ?? '').isEmpty ? "" : ' /'} ${productModel?.individualInfo?.locationProvince}',
                            style: regular.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                        ])),
                        Row(
                          children: [
                            if (productModel?.priceInfo?.credit ?? false)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.checkmark_alt,
                                    size: 15.r,
                                    color: Get.theme.disabledColor,
                                  ),
                                  Text(
                                    'Credit',
                                    style: regular.copyWith(
                                      color: Get.theme.disabledColor,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            if (productModel?.priceInfo?.possibleExchange ??
                                false)
                              5.horizontalSpace,
                            if (productModel?.priceInfo?.possibleExchange ??
                                false)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.checkmark_alt,
                                    size: 15.r,
                                    color: Get.theme.disabledColor,
                                  ),
                                  Text(
                                    'exchange',
                                    style: regular.copyWith(
                                      color: Get.theme.disabledColor,
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (isShowLikeButton)
              Positioned(
                right: 10.w,
                top: 4.h,
                child: InkWell(
                  onTap: () {},
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
                    child: Obx(() {
                      return productController.isProductLike.value &&
                              productController.productLikeId.value ==
                                  (productModel?.id ?? '')
                          ? const CupertinoActivityIndicator(
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 20.r,
                            );
                    }),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

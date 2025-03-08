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
  final bool showBorder;
  final bool isShowLikeButton;
  const ProductListTile({super.key, this.productModel, this.isShowLikeButton = false, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find();
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsView(productModel: productModel), transition: Transition.fadeIn);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 3.h,
          horizontal: 14.w,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        height: 110.h,
        decoration: BoxDecoration(
          color: Get.theme.appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5.r),
          border: showBorder
              ? Border.all(
                  color: Get.theme.disabledColor.withOpacity(0.2),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Get.theme.disabledColor.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
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
                      ? NetworkImagePreview(
                          radius: 5.r,
                          url: productModel?.media?.firstOrNull?.name ?? '',
                          height: 110.h,
                          width: 100.h,
                          fit: BoxFit.cover,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            carImage,
                            height: 110.h,
                            width: 100.h,
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(children: [
                              TextSpan(
                                text: productModel?.title ?? 'Hyundai santa fe ',
                                style: regular.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ])),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          productModel?.description ?? 'Lorem ipsum is placeholder text  ',
                          style: regular.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "\$${productModel?.priceInfo?.price ?? 96.00}  ",
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${productModel?.individualInfo?.locationCity} ${(productModel?.individualInfo?.locationCity ?? '').isEmpty ? "" : ' /'} ${productModel?.individualInfo?.locationProvince}',
                            style: regular.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ])),
                        if ((productModel?.carInfo?.brand?.isNotEmpty ?? false) ||
                            (productModel?.phoneInfo?.brand?.isNotEmpty ?? false) ||
                            (productModel?.estateInfo?.address?.isNotEmpty ?? false))
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
                                    color: (productModel?.priceInfo?.credit ?? false)
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
                                    (productModel?.priceInfo?.possibleExchange ?? false)
                                        ? CupertinoIcons.checkmark_alt
                                        : CupertinoIcons.xmark,
                                    size: 15.r,
                                    color: (productModel?.priceInfo?.possibleExchange ?? false)
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
                              productController.productLikeId.value == (productModel?.id ?? '')
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

import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../models/item_model.dart';

class ItemWidget extends GetView<FilterController> {
  const ItemWidget({
    super.key,
    this.itemModel,
  });
  final ItemModel? itemModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.r),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(14.r)),
            child: CachedNetworkImage(
              imageUrl: controller.getRandomImageUrl(),
              height: 100.h,
              width: 90.w,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  "assets/images/placeholder.jpg",
                  height: 100.h,
                  width: 90.w,
                  fit: BoxFit.cover,
                ),
              ),
              placeholder: (context, url) => Image.asset(
                "assets/images/placeholder.jpg",
                height: 100.h,
                width: 90.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          20.horizontalSpace,
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "${itemModel?.carInfo?.brand ?? ''} ${itemModel?.carInfo?.model ?? ''}",
                        maxLines: 1,
                        style: bold,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      itemModel?.carInfo?.year.toString() ?? '',
                      style: bold.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  itemModel?.description ?? '',
                  maxLines: 1,
                  style: medium.copyWith(fontSize: 12.sp),
                ),
                6.verticalSpace,
                Row(
                  children: [
                    Text(
                      "\$ ${itemModel?.priceInfo?.price.toString() ?? ''}",
                      maxLines: 1,
                      style: bold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      " | ",
                      style: bold.copyWith(
                        color: AppColors.liteGray,
                        fontSize: 16.sp,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        itemModel?.individualInfo?.location ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: medium.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  ],
                ),
                8.verticalSpace,
                Row(
                  children: [
                    Row(
                      children: [
                        itemModel?.priceInfo?.credit ?? false
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                                size: 16.sp,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 16.sp,
                              ),
                        2.horizontalSpace,
                        Text(
                          "Credit",
                          style: medium.copyWith(
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                    10.horizontalSpace,
                    Row(
                      children: [
                        itemModel?.priceInfo?.possibleExchange ?? false
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                                size: 16.sp,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 16.sp,
                              ),
                        2.horizontalSpace,
                        Text(
                          "Exchange",
                          style: medium.copyWith(
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

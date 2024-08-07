import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

class FilterResultsView extends GetView<FilterController> {
  const FilterResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Filter Results",
          style: bold.copyWith(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.itemList.isEmpty) {
            return Center(
              child: Text(
                "No matching results found!",
                style: medium.copyWith(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
            itemCount: controller.itemList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
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
                                  "${controller.itemList[index].carInfo?.brand ?? ''} ${controller.itemList[index].carInfo?.model ?? ''}",
                                  maxLines: 1,
                                  style: bold,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                controller.itemList[index].carInfo?.year.toString() ?? '',
                                style: bold.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          Text(
                            controller.itemList[index].description ?? '',
                            maxLines: 1,
                            style: medium.copyWith(fontSize: 12.sp),
                          ),
                          6.verticalSpace,
                          Row(
                            children: [
                              Text(
                                "\$ ${controller.itemList[index].priceInfo?.price.toString() ?? ''}",
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
                                  controller.itemList[index].individualInfo?.location ?? '',
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
                                  controller.itemList[index].priceInfo?.credit ?? false
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
                                  controller.itemList[index].priceInfo?.possibleExchange ?? false
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
            },
          );
        },
      ),
    );
  }
}

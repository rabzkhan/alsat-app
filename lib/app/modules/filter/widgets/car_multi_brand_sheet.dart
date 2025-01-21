import 'package:alsat/app/modules/app_home/models/car_brand_res.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class CarMultiBrandBottomSheet extends StatefulWidget {
  const CarMultiBrandBottomSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
  });
  final String title;
  final RxList<BrandModel> data;
  final RxList<BrandModel> selectedData;

  @override
  State<CarMultiBrandBottomSheet> createState() =>
      _CarMultiBrandBottomSheetState();
}

class _CarMultiBrandBottomSheetState extends State<CarMultiBrandBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: bold.copyWith(fontSize: 16.sp),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (widget.selectedData.value
                        .contains(widget.data[index])) {
                      widget.selectedData.value.remove(widget.data[index]);
                    } else {
                      widget.selectedData.value.add(widget.data[index]);
                    }

                    setState(() {});
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Text(
                            widget.data[index].brand ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        widget.selectedData.value.contains(widget.data[index])
                            ? Container(
                                height: 22.h,
                                width: 22.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.done,
                                  size: 20.h,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                height: 22.h,
                                width: 22.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.liteGray,
                                  shape: BoxShape.circle,
                                ),
                              )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

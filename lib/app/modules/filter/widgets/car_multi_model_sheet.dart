import 'package:alsat/app/modules/app_home/models/car_brand_res.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class CarMultiModelBottomSheet extends StatefulWidget {
  const CarMultiModelBottomSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
    required this.onSelect,
  });
  final String title;
  final Function(List<CarModel>) onSelect;
  final List<CarModel> data;
  final List<CarModel> selectedData;

  @override
  State<CarMultiModelBottomSheet> createState() =>
      _CarMultiModelBottomSheetState();
}

class _CarMultiModelBottomSheetState extends State<CarMultiModelBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
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
                    if (widget.selectedData.contains(widget.data[index])) {
                      widget.selectedData.remove(widget.data[index]);
                    } else {
                      widget.selectedData.add(widget.data[index]);
                    }
                    setState(() {});
                    widget.onSelect(widget.selectedData);
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
                            widget.data[index].name ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        widget.selectedData.contains(widget.data[index])
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

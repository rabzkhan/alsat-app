import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
  });
  final String title;
  final RxList<String> data;
  final RxString selectedData;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
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
                    if (widget.selectedData.value == widget.data[index]) {
                      widget.selectedData.value = "Not Chsen Yet";
                    } else {
                      widget.selectedData.value = widget.data[index];
                    }

                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Text(
                            widget.data[index],
                            style: medium.copyWith(),
                          ),
                        ),
                        widget.selectedData.value == widget.data[index]
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

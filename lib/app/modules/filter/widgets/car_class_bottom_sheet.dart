import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class CarMultiSelectClassBottomSheet extends StatefulWidget {
  const CarMultiSelectClassBottomSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
    required this.onSelect,
  });

  final String title;
  final List<String> data;
  final List<String> selectedData;
  final Function(List<String>) onSelect;

  @override
  State<CarMultiSelectClassBottomSheet> createState() => _CarMultiSelectClassBottomSheetState();
}

class _CarMultiSelectClassBottomSheetState extends State<CarMultiSelectClassBottomSheet> {
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
                      icon: const Icon(Icons.close),
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
              const Expanded(child: SizedBox()),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final className = widget.data[index];
                final isSelected = widget.selectedData.contains(className);

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        widget.selectedData.remove(className);
                      } else {
                        widget.selectedData.add(className);
                      }
                      widget.onSelect(widget.selectedData);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 20.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Text(
                            className,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Container(
                          height: 22.h,
                          width: 22.w,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.liteGray,
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.done,
                                  size: 20.h,
                                  color: Colors.white,
                                )
                              : null,
                        ),
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

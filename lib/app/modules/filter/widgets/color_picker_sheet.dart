// ignore_for_file: deprecated_member_use

import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
    this.isMulti = true,
  });
  final bool isMulti;
  final String title;
  final RxList<Map<String, Color>> data;
  final RxList<String> selectedData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
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
                  title,
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
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 0.w,
                mainAxisSpacing: 0.h,
                childAspectRatio: 1,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final currentItem = data[index];
                  final key = currentItem.keys.first;
                  final isSelected = selectedData.contains(key);
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: !isSelected ? Colors.transparent : AppColors.primary.withOpacity(0.2),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          selectedData.remove(key);
                        } else {
                          selectedData.add(key);
                        }
                        if (!isMulti) {
                          Get.back();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 55.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: data[index].values.first,
                              border: data[index].values.first == Colors.white
                                  ? Border.all(
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                          ),
                          5.verticalSpace,
                          Text(
                            data[index].keys.first,
                            style: regular.copyWith(
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .15),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: AppColors.primary,
                    child: Text(
                      'Ok',
                      style: medium.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      Get.back(result: selectedData);
                    },
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}

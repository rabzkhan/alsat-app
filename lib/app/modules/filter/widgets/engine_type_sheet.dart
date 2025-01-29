import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class EngineTypeSheet extends StatefulWidget {
  const EngineTypeSheet({
    super.key,
    required this.title,
    required this.data,
    required this.selectedData,
  });
  final String title;
  final RxList<String> data;
  final RxString selectedData;

  @override
  State<EngineTypeSheet> createState() => _EngineTypeSheetState();
}

class _EngineTypeSheetState extends State<EngineTypeSheet> {
  late ScrollController scrollController;

  @override
  void initState() {
    int initialItem = widget.data.indexOf(widget.selectedData.value);
    scrollController = FixedExtentScrollController(initialItem: initialItem);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
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
            child: Container(
              margin: EdgeInsets.only(bottom: 30.h),
              width: Get.width * .6,
              child: Scrollbar(
                thickness: 1.w,
                controller: scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: ListWheelScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  squeeze: 1,
                  onSelectedItemChanged: (value) {
                    if (widget.selectedData.value == widget.data[value]) {
                      widget.selectedData.value = "Not Chsen Yet";
                    } else {
                      widget.selectedData.value = widget.data[value];
                    }
                  },
                  itemExtent: 35.h,
                  children: List.generate(
                    widget.data.length,
                    (index) {
                      return Obx(() {
                        return Container(
                          alignment: Alignment.center,
                          width: Get.width * .4,
                          padding: EdgeInsets.symmetric(
                              vertical: 7.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.selectedData.value ==
                                      widget.data[index]
                                  ? AppColors.primary.withOpacity(.4)
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            widget.data[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

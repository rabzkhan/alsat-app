import 'dart:math';

import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SingleYearPicker extends StatefulWidget {
  final RxString selectYear;
  const SingleYearPicker({super.key, required this.selectYear});

  @override
  State<SingleYearPicker> createState() => _SingleYearPickerState();
}

class _SingleYearPickerState extends State<SingleYearPicker> {
  late double widgetHeight;
  late ScrollController scrollController;
  List<String> items = [];
  String selectYear = '0';
  @override
  void initState() {
    selectYear = widget.selectYear.value;
    items = List.generate(
        100, (index) => (index + (num.parse(selectYear) - 50)).toString());
    int initialItem = items.indexOf(widget.selectYear.value);
    scrollController = FixedExtentScrollController(initialItem: initialItem);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle? defaultStyle = themeData.textTheme.bodyMedium;
    TextStyle? selectedStyle = themeData.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w)
              .copyWith(bottom: 8.h),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child:
                    Text('Select Year', style: themeData.textTheme.titleMedium),
              ),
              10.verticalSpace,
              Expanded(
                child: Row(
                  children: [
                    20.verticalSpace,
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTapUp: _itemTapped,
                            child: ListWheelScrollView.useDelegate(
                              childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (BuildContext context, int index) {
                                if (index < 0 || index > items.length - 1) {
                                  return null;
                                }

                                var value = items[index];

                                return Center(
                                  child: Text(
                                    '$value',
                                    style: (value == selectYear)
                                        ? selectedStyle
                                        : defaultStyle,
                                  ),
                                );
                              }),
                              controller: scrollController,
                              itemExtent: 50,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectYear = items[index];
                                  widget.selectYear.value = selectYear;
                                });
                              },
                              physics: const FixedExtentScrollPhysics(),
                            ),
                          ),
                          const Divider(),
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              height: 50,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.primary,
                                    width: .8,
                                  ),
                                  bottom: BorderSide(
                                    color: AppColors.primary,
                                    width: .8,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    10.verticalSpace,
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController.offset + changeBy;
    scrollController.animateTo(newPosition,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}

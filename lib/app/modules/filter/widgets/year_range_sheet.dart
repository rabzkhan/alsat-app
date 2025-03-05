import 'package:alsat/app/modules/filter/widgets/filter_option_widget.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/filter_controller.dart';

class FilterYearRangePicker extends StatefulWidget {
  const FilterYearRangePicker({super.key});

  @override
  State<FilterYearRangePicker> createState() => _FilterYearRangePickerState();
}

class _FilterYearRangePickerState extends State<FilterYearRangePicker> {
  late double widgetHeight;
  late ScrollController scrollController;
  late ScrollController scrollController2;
  final List<int> items = List.generate(1000, (index) => index + 1900);

  final FilterController filterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FilterOptionWidget(
        title: "Year",
        subTitle: "${filterController.choseFirstYear.value} - ${filterController.choseLastYear.value}",
        onTap: () {
          showCustomDialog(context);
        },
      );
    });
  }

  showCustomDialog(BuildContext context) {
    int initialItem = items.indexOf(filterController.choseFirstYear.value);
    int initialItem2 = items.indexOf(filterController.choseLastYear.value);
    scrollController = FixedExtentScrollController(initialItem: initialItem);
    scrollController2 = FixedExtentScrollController(initialItem: initialItem2);
    final ThemeData themeData = Theme.of(context);
    TextStyle? defaultStyle = themeData.textTheme.bodyMedium;
    TextStyle? selectedStyle = themeData.textTheme.bodyLarge?.copyWith(color: themeData.colorScheme.secondary);
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            widgetHeight = constraints.maxHeight;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w).copyWith(bottom: 8.h),
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
                    child: Text(localLanguage.year_range, style: themeData.textTheme.titleMedium),
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
                                  childDelegate:
                                      ListWheelChildBuilderDelegate(builder: (BuildContext context, int index) {
                                    if (index < 0 || index > items.length - 1) {
                                      return null;
                                    }

                                    var value = items[index];

                                    return Center(
                                      child: Obx(() {
                                        return Text(
                                          '$value',
                                          style: (value == filterController.choseFirstYear.value)
                                              ? selectedStyle
                                              : defaultStyle,
                                        );
                                      }),
                                    );
                                  }),
                                  controller: scrollController,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      filterController.choseFirstYear.value = items[index];
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
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTapUp: _itemTapped,
                                child: ListWheelScrollView.useDelegate(
                                  childDelegate:
                                      ListWheelChildBuilderDelegate(builder: (BuildContext context, int index) {
                                    if (index < 0 || index > items.length - 1) {
                                      return null;
                                    }

                                    var value = items[index];

                                    return Center(
                                      child: Obx(() {
                                        return Text(
                                          '$value',
                                          style: (value == filterController.choseLastYear.value)
                                              ? selectedStyle
                                              : defaultStyle,
                                        );
                                      }),
                                    );
                                  }),
                                  controller: scrollController2,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      filterController.choseLastYear.value = items[index];
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
      },
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController.offset + changeBy;
    scrollController.animateTo(newPosition, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}

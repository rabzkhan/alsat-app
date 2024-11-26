import 'dart:developer';

import 'package:alsat/app/global/app_decoration.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import '../../app_home/models/car_brand_res.dart';
import '../../product/controller/product_controller.dart';
import '../../product/widget/category_selection.dart';
import '../widgets/car_model_sheet.dart';
import '../widgets/car_multi_brand_sheet.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_option_widget.dart';
import '../widgets/multi_filter_bottom_sheet.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  //realstate style
  String output = '';
  String? deletedChip, deletedChipIndex;
  final keySimpleChipsInput = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  final TextFormFieldStyle style = TextFormFieldStyle(
    keyboardType: TextInputType.text,
    cursorColor: Colors.black,
    decoration: InputDecoration(
      labelText: 'Real Estate Type',
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
      ),
      contentPadding: const EdgeInsets.all(0.0),
      border: InputBorder.none,
      // isDense: true,
      // isCollapsed: true,
    ),
  );
  //
  ProductController productController = Get.find();
  FilterController controller = Get.find();
  HomeController homeController = Get.find();

  @override
  void initState() {
    productController.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final credit = ValueNotifier<bool>(controller.credit.value);
    final exchange = ValueNotifier<bool>(controller.exchange.value);
    final hasVin = ValueNotifier<bool>(controller.hasVinCode.value);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0.4,
            centerTitle: true,
            title: Image.asset(
              "assets/icons/appicon.png",
              height: 30.h,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "Filter",
                textAlign: TextAlign.center,
                style: medium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          // //Category Section
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      const CategorySelection(valueReturn: true),
                ).then((value) {
                  log('Category Selection: $value');
                  controller.category.value = value;
                  // productController.calculateFilledProductFields();
                });
              },
              child: Container(
                decoration: borderedContainer,
                margin:
                    EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 14.h),
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 12.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: bold.copyWith(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                        2.verticalSpace,
                        Obx(() {
                          return Text(
                            (controller.category.value?.name ??
                                    'Select Category')
                                .toString(),
                            style: bold.copyWith(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          );
                        }),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.h,
                      color: AppColors.primary,
                    )
                  ],
                ),
              ),
            ),
          ),

          // //Location Section
          SliverToBoxAdapter(
            child: Container(
              decoration: borderedContainer,
              margin:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: bold.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      2.verticalSpace,
                      Obx(() {
                        return productController.placemarks.isEmpty
                            ? const Center()
                            : Text(
                                "${productController.placemarks.last.street} ${productController.placemarks.first.subLocality} ${productController.placemarks.first.administrativeArea}",
                                style: regular.copyWith(
                                  fontSize: 10.sp,
                                  color: context.theme.primaryColor,
                                ),
                              );
                      }),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 30.h,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),
          ),

          // //Condition section
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Text(
                      "Condition",
                      style: bold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  6.verticalSpace,
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => ElevatedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      controller.condition.value == "All"
                                          ? Colors.white
                                          : Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  controller.condition.value = "All";
                                },
                                child: const Text(
                                  "All",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(() => ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          controller.condition.value ==
                                                  "Brand New"
                                              ? Colors.white
                                              : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.condition.value = "Brand New";
                                  },
                                  child: const Text(
                                    "Brand New",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Obx(() => ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          controller.condition.value == "Used"
                                              ? Colors.white
                                              : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.condition.value = "Used";
                                  },
                                  child: const Text(
                                    "Used",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // //Price Section
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 10.h),
                    child: Text(
                      "Price",
                      style: bold.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: controller.priceFrom.value,
                          onChanged: (value) {},
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.textFieldGray,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0.r),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'From',
                            hintStyle: medium.copyWith(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                      Expanded(
                        child: TextField(
                          controller: controller.priceTo.value,
                          onChanged: (value) {},
                          autofocus: false,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.textFieldGray,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0.r),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'To',
                            hintStyle: medium.copyWith(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // //Brand Section
          // //Location Section
          SliverToBoxAdapter(
            child: Obx(() {
              return controller.category.value?.name?.toLowerCase() ==
                      'automobile'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //*Brand Section
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              CarMultiBrandBottomSheet(
                                title: "Brand",
                                data: homeController.brandList,
                                selectedData: controller.brand,
                              ),
                            ).then((_) {
                              controller.brand.refresh();
                            });
                          },
                          child: Container(
                            decoration: borderedContainer,
                            margin: EdgeInsets.symmetric(horizontal: 16.w)
                                .copyWith(top: 16.h, bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 12.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Brand",
                                      style: bold.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    3.verticalSpace,
                                    Obx(
                                      () => SizedBox(
                                        height: 20.h,
                                        width: Get.width - 90.w,
                                        child: controller.brand.isEmpty
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 4.w),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 2.h,
                                                ),
                                                child: Text(
                                                  'Choose Brand',
                                                  style: medium.copyWith(
                                                    fontSize: 10.sp,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              )
                                            : ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: controller.brand
                                                    .map((brand) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .textFieldGray,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(4.0.r),
                                                      ),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        right: 4.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 2.h,
                                                      horizontal: 4.w,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        brand.brand ??
                                                            'Choose Brand',
                                                        style: medium.copyWith(
                                                          fontSize: 10.sp,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList()),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 30.h,
                                  color: AppColors.liteGray,
                                )
                              ],
                            ),
                          ),
                        ),
                        //*model section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() => FilterOptionWidget(
                                      title: "Model",
                                      subTitle: controller.model.value?.name ??
                                          'Choose Model',
                                      onTap: () {
                                        Get.bottomSheet(
                                          CarModelBottomSheet(
                                            title: "Model",
                                            data: (controller.brand.value)
                                                .expand((e) =>
                                                    e.model ?? <CarModel>[])
                                                .toList(),
                                            selectedData: controller.model,
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Obx(() => FilterOptionWidget(
                                      title: "Body Type",
                                      subTitle: controller.bodyType.value,
                                      onTap: () {
                                        Get.bottomSheet(
                                          FilterBottomSheet(
                                            title: "Body Type",
                                            data: controller.dbodyType,
                                            selectedData: controller.bodyType,
                                          ),
                                        );
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                        // drive type
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => FilterOptionWidget(
                                    title: "Drive Type",
                                    subTitle: controller.driveType.value,
                                    onTap: () {
                                      Get.bottomSheet(
                                        FilterBottomSheet(
                                          title: "Drive Type",
                                          data: controller.ddriveType,
                                          selectedData: controller.driveType,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Obx(
                                  () => FilterOptionWidget(
                                    title: "Engine Type",
                                    subTitle: controller.engineType.value,
                                    onTap: () {
                                      Get.bottomSheet(
                                        FilterBottomSheet(
                                          title: "Engine Type",
                                          data: controller.dengineType,
                                          selectedData: controller.engineType,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // transmission
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() => FilterOptionWidget(
                                      title: "Transmission",
                                      subTitle: controller.transmission.value,
                                      onTap: () {
                                        Get.bottomSheet(
                                          FilterBottomSheet(
                                            title: "Transmission",
                                            data: controller.dtransmission,
                                            selectedData:
                                                controller.transmission,
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: FilterOptionWidget(
                                  title: "Year",
                                  subTitle: "1994 - 2009",
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        //color
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => FilterOptionWidget(
                                    title: "Color",
                                    subTitle: controller.color.value
                                        .expand((e) => [e.toString()])
                                        .join(', '),
                                    onTap: () {
                                      Get.bottomSheet(
                                        MultiFilterBottomSheet(
                                          title: "Color",
                                          data: controller.dcolor,
                                          selectedData: controller.color,
                                        ),
                                      ).then((_) {
                                        controller.color.refresh();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: FilterOptionWidget(
                                  title: "Mileage",
                                  subTitle: " ~ km",
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : controller.category.value?.name?.toLowerCase() ==
                          'real estate'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.textFieldGray,
                                ),
                              ),
                              child: SimpleChipsInput(
                                separatorCharacter: ",",
                                focusNode: focusNode,
                                validateInput: true,
                                formKey: keySimpleChipsInput,
                                textFormFieldStyle: style,
                                validateInputMethod: (String value) {},
                                onSubmitted: (p0) {
                                  setState(() {
                                    output = p0;
                                  });
                                },
                                onChipDeleted: (p0, p1) {
                                  setState(() {
                                    deletedChip = p0;
                                    deletedChipIndex = p1.toString();
                                  });
                                },
                                onSaved: ((p0) {
                                  setState(() {
                                    output = p0;
                                  });
                                }),
                                chipTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                                deleteIcon: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    size: 16.r,
                                    color: Colors.black,
                                  ),
                                ),
                                widgetContainerDecoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                chipContainerDecoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                placeChipsSectionAbove: false,
                              ),
                            )
                          ],
                        )
                      : controller.category.value?.name?.toLowerCase() ==
                              'phone'
                          ? Center()
                          : Center();
            }),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w)
                  .copyWith(top: 20.h, left: 12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "Credit",
                          style: bold.copyWith(fontSize: 14.sp),
                        ),
                      ),
                      AdvancedSwitch(
                        onChanged: (value) {
                          controller.credit.value = value;
                        },
                        controller: credit,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.grey,
                        width: 45.0,
                        height: 25.h,
                        enabled: true,
                        disabledOpacity: 0.5,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "Exchange",
                          style: bold.copyWith(fontSize: 14.sp),
                        ),
                      ),
                      AdvancedSwitch(
                        onChanged: (value) {
                          controller.exchange.value = value;
                        },
                        controller: exchange,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.grey,
                        width: 45.0,
                        height: 25.h,
                        enabled: true,
                        disabledOpacity: 0.5,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "Has A VIN Code",
                          style: bold.copyWith(fontSize: 14.sp),
                        ),
                      ),
                      AdvancedSwitch(
                        onChanged: (value) {
                          controller.hasVinCode.value = value;
                        },
                        controller: hasVin,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.grey,
                        width: 45.0,
                        height: 25.h,
                        enabled: true,
                        disabledOpacity: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 30.h,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 60.h,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    controller.applyFilter();
                  },
                  child: Obx(() {
                    if (controller.isFilterLoading.value) {
                      return SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        ),
                      );
                    }
                    return const Text(
                      "Filter",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30.h,
            ),
          ),
        ],
      ),
    );
  }
}

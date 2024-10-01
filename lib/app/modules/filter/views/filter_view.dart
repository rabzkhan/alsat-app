import 'package:alsat/app/global/app_decoration.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_option_widget.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({super.key});

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
            child: Container(
              decoration: borderedContainer,
              margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 14.h),
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
                      Text(
                        controller.category.toString(),
                        style: bold.copyWith(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
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

          // //Location Section
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  FilterBottomSheet(
                    title: "Location",
                    data: controller.dlocation,
                    selectedData: controller.location,
                  ),
                );
              },
              child: Container(
                decoration: borderedContainer,
                margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
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
                        Obx(
                          () => Text(
                            controller.location.value,
                            style: medium.copyWith(
                              fontSize: 10.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
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

          // //Condition section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 12.h),
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
                                      controller.condition.value == "All" ? Colors.white : Colors.transparent,
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
                                          controller.condition.value == "Brand New" ? Colors.white : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
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
                                          controller.condition.value == "Used" ? Colors.white : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
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
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  FilterBottomSheet(
                    title: "Brand",
                    data: controller.dbrand,
                    selectedData: controller.brand,
                  ),
                );
              },
              child: Container(
                decoration: borderedContainer,
                margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h, bottom: 10.h),
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
                        2.verticalSpace,
                        Obx(
                          () => Text(
                            controller.brand.value,
                            style: medium.copyWith(
                              fontSize: 10.sp,
                              color: Colors.black54,
                            ),
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
          ),

          // //
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => FilterOptionWidget(
                          title: "Model",
                          subTitle: controller.model.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Model",
                                data: controller.dmodel,
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
          ),

          SliverToBoxAdapter(
            child: Padding(
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
          ),
          SliverToBoxAdapter(
            child: Padding(
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
                                selectedData: controller.transmission,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => FilterOptionWidget(
                        title: "Color",
                        subTitle: controller.color.value,
                        onTap: () {
                          Get.bottomSheet(
                            FilterBottomSheet(
                              title: "Color",
                              data: controller.dcolor,
                              selectedData: controller.color,
                            ),
                          );
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
          ),
          // //Toggle Switches

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 20.h, left: 12.w),
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

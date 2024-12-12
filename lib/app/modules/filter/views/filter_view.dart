import 'dart:developer';

import 'package:alsat/app/components/scrolling_text.dart';
import 'package:alsat/app/global/app_decoration.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/modules/filter/views/filter_results_view.dart';
import 'package:alsat/app/modules/filter/views/location_selection.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import '../../../components/custom_appbar.dart';
import '../../app_home/models/car_brand_res.dart';
import '../../product/controller/product_controller.dart';
import '../../product/widget/category_selection.dart';
import '../widgets/car_model_sheet.dart';
import '../widgets/car_multi_brand_sheet.dart';
import '../widgets/car_multi_model_sheet.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final credit = ValueNotifier<bool>(controller.credit.value);
    final exchange = ValueNotifier<bool>(controller.exchange.value);
    final hasVin = ValueNotifier<bool>(controller.hasVinCode.value);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: const SafeArea(
          child: CustomAppBar(
            isShowBackButton: true,
            isShowFilter: false,
            isShowSearch: false,
            isShowNotification: false,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
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
            child: GestureDetector(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      const LocationSelection(canSelectMultiple: true),
                );
              },
              child: Container(
                decoration: borderedContainer,
                margin:
                    EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 12.w,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
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
                          // Text(
                          //   "Choose Location",
                          //   style: regular.copyWith(
                          //     fontSize: 10.sp,
                          //     color: context.theme.primaryColor,
                          //   ),
                          // ),
                          Obx(() {
                            // Get the selected location text from the controller
                            String selectedLocationText =
                                Get.find<FilterController>()
                                    .getSelectedLocationText();
                            return Row(
                              children: [
                                Expanded(
                                  child: ScrollingTextWidget(
                                    child: Text(
                                      selectedLocationText, // Display selected location text here
                                      style: regular.copyWith(
                                        fontSize: 10.sp,
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
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
          SliverToBoxAdapter(
            child: Obx(() {
              return controller.category.value?.name?.toLowerCase() == 'phone'
                  ? GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          MultiFilterBottomSheet(
                            title: "Mobile Brand",
                            data: controller.mobileBrand,
                            selectedData: controller.selectMobileBrand,
                          ),
                        ).then((_) {
                          controller.selectMobileBrand.refresh();
                        });
                      },
                      child: Container(
                        decoration: borderedContainer,
                        margin: EdgeInsets.symmetric(horizontal: 16.w)
                            .copyWith(top: 10.h),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
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
                                  Obx(() {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ScrollingTextWidget(
                                            child: Text(
                                              controller
                                                      .selectMobileBrand.isEmpty
                                                  ? 'Not Choose Yet'
                                                  : controller.selectMobileBrand
                                                      .expand(
                                                          (e) => [e.toString()])
                                                      .join(', '),
                                              style: regular.copyWith(
                                                fontSize: 10.sp,
                                                color:
                                                    context.theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 30.h,
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    )
                  : controller.category.value?.name?.toLowerCase() ==
                          'real estate'
                      ? GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              MultiFilterBottomSheet(
                                title: "Mobile Brand",
                                data: controller.estateTtypeList,
                                selectedData: controller.estateTtype,
                              ),
                            ).then((_) {
                              controller.estateTtype.refresh();
                            });
                          },
                          child: Container(
                            decoration: borderedContainer,
                            margin: EdgeInsets.symmetric(horizontal: 16.w)
                                .copyWith(top: 10.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 12.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Estate Type",
                                        style: bold.copyWith(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      2.verticalSpace,
                                      Obx(() {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: ScrollingTextWidget(
                                                child: Text(
                                                  controller.estateTtype.isEmpty
                                                      ? 'Not Choose Yet'
                                                      : controller.estateTtype
                                                          .expand((e) =>
                                                              [e.toString()])
                                                          .join(', '),
                                                  style: regular.copyWith(
                                                    fontSize: 10.sp,
                                                    color: context
                                                        .theme.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 30.h,
                                  color: AppColors.primary,
                                )
                              ],
                            ),
                          ),
                        )
                      : const Center();
            }),
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
                                      controller.condition.value == ""
                                          ? Colors.white
                                          : Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  controller.condition.value = "";
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
                                          controller.condition.value == "new"
                                              ? Colors.white
                                              : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.condition.value = "new";
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
                                          controller.condition.value == "used"
                                              ? Colors.white
                                              : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.condition.value = "used";
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
                              controller.brandAndSelectedModel.clear();
                              for (var element in controller.brand) {
                                controller.brandAndSelectedModel.add({
                                  'brand': element,
                                  'model': <CarModel>[],
                                });
                              }
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
                          child: Obx(() {
                            return Wrap(
                              spacing: 10.w,
                              children: [
                                ...List.generate(
                                  controller.brandAndSelectedModel.length,
                                  (index) {
                                    var brand =
                                        controller.brandAndSelectedModel[index];
                                    return SizedBox(
                                      width: (Get.width /
                                              (controller.brand.length > 1
                                                  ? 2
                                                  : 1)) -
                                          26.w,
                                      child: FilterOptionWidget(
                                        title: "Model ",
                                        titleSub:
                                            '*(${brand['brand'].brand ?? ''})',
                                        subTitle: controller
                                                .brandAndSelectedModel[index]
                                                    ['model']
                                                .isEmpty
                                            ? 'Choose Model'
                                            : '${controller.brandAndSelectedModel[index]['model'].toList().expand((e) => [
                                                  e.name.toString()
                                                ]).join(', ')}',
                                        onTap: () {
                                          Get.bottomSheet(
                                            CarMultiModelBottomSheet(
                                              title: "Model",
                                              data: (brand['brand'].model ??
                                                      <CarModel>[])
                                                  .toList(),
                                              selectedData: controller
                                                      .brandAndSelectedModel[
                                                  index]['model'],
                                              onSelect: (p0) {
                                                controller
                                                        .brandAndSelectedModel[
                                                    index]['model'] = p0;
                                                controller.brandAndSelectedModel
                                                    .refresh();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
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
                                    subTitle: controller.color.value.isEmpty
                                        ? 'Not Choose Yet'
                                        : controller.color.value
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
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w)
                              .copyWith(top: 16.h, bottom: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.h,
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Get.theme.primaryColor
                                          .withOpacity(.4),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Floor',
                                        style: bold.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      3.verticalSpace,
                                      FormBuilderTextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        controller: productController.room,
                                        name: 'floor',
                                        onChanged: (newValue) {},
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Get.theme.primaryColor
                                              .withOpacity(.6),
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.liteGray
                                              .withOpacity(.3),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.h,
                                          ),
                                          isDense: true,
                                          alignLabelWithHint: true,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: '',
                                          labelStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Get.theme.primaryColor
                                                .withOpacity(.6),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        validator:
                                            FormBuilderValidators.compose([]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              20.horizontalSpace,
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.h,
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Get.theme.primaryColor
                                          .withOpacity(.4),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room',
                                        style: bold.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      3.verticalSpace,
                                      FormBuilderTextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*')),
                                        ],
                                        controller: productController.room,
                                        name: 'room',
                                        onChanged: (newValue) {},
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Get.theme.primaryColor
                                              .withOpacity(.6),
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.liteGray
                                              .withOpacity(.3),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.h,
                                          ),
                                          isDense: true,
                                          alignLabelWithHint: true,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: '',
                                          labelStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Get.theme.primaryColor
                                                .withOpacity(.6),
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        validator:
                                            FormBuilderValidators.compose([]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
                  Obx(() {
                    return controller.category.value?.name?.toLowerCase() ==
                            'automobile'
                        ? Row(
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
                          )
                        : const Center();
                  }),
                  //Sort
                  10.verticalSpace,
                  ExpansionTile(
                    dense: true,
                    iconColor: context.theme.primaryColor,
                    collapsedIconColor: context.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                        color: context.theme.primaryColor.withOpacity(.5),
                        width: .8,
                      ),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                        color: context.theme.primaryColor.withOpacity(.5),
                        width: .8,
                      ),
                    ),
                    title: Text(
                      'Sort',
                      style: bold.copyWith(fontSize: 16.sp),
                    ),
                    subtitle: Obx(() {
                      return Text(
                        controller.sortValue.isEmpty
                            ? 'Not chosen yet'
                            : controller.sortValue.value,
                        style: regular.copyWith(
                          fontSize: 10.sp,
                          color: context.theme.textTheme.bodyLarge!.color!
                              .withOpacity(.7),
                        ),
                      );
                    }),
                    children: [
                      _shortTile(title: 'Default'),
                      _shortTile(title: 'The newest'),
                      _shortTile(title: 'The Cheaper price first'),
                      _shortTile(title: 'The highest price first'),
                      15.verticalSpace,
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
                child: Obx(() {
                  return ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: controller.category.value == null
                          ? AppColors.liteGray
                          : AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: controller.category.value == null
                        ? null
                        : () {
                            log('filter');
                            controller.isFilterLoading.value = true;
                            controller.filtermapPassed = null;
                            controller.applyFilter();
                            Get.to(const FilterResultsView(),
                                transition: Transition.rightToLeft);
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
                  );
                }),
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

  InkWell _shortTile({required String title}) {
    return InkWell(
      onTap: () {
        controller.sortValue.value = title;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 6.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: regular.copyWith(fontSize: 12.sp),
              ),
            ),
            CircleAvatar(
              radius: 10.r,
              backgroundColor: AppColors.liteGray,
              child: Obx(() {
                return controller.sortValue.value == title
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20.r,
                      )
                    : const Center();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

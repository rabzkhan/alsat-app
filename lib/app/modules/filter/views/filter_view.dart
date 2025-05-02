// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:alsat/app/components/scrolling_text.dart';
import 'package:alsat/app/global/app_decoration.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/modules/filter/views/filter_results_view.dart';
import 'package:alsat/app/modules/filter/views/location_selection.dart';
import 'package:alsat/app/modules/filter/widgets/year_range_sheet.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import '../../../components/custom_appbar.dart';
import '../../app_home/models/car_brand_res.dart';
import '../../product/controller/product_controller.dart';
import '../../product/widget/category_selection.dart';
import '../../product/widget/single_year_picker.dart';
import '../widgets/car_multi_brand_sheet.dart';
import '../widgets/car_multi_model_sheet.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_option_widget.dart';
import '../widgets/multi_filter_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterView extends StatefulWidget {
  final bool isBack;
  final Map<String, dynamic>? preData;
  const FilterView({super.key, required this.isBack, this.preData});

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
    final localLanguage = AppLocalizations.of(Get.context!)!;
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
                localLanguage.filter,
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
                  builder: (context) => const CategorySelection(valueReturn: true),
                ).then((value) {
                  log('Category Selection: $value');
                  controller.category.value = value;
                  // productController.calculateFilledProductFields();
                });
              },
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
                          localLanguage.category,
                          style: bold.copyWith(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                        2.verticalSpace,
                        Obx(() {
                          return Text(
                            (controller.category.value?.name ?? localLanguage.select_category).toString(),
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
                  builder: (context) => const LocationSelection(canSelectMultiple: true),
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
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            localLanguage.location,
                            style: bold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          2.verticalSpace,
                          Obx(() {
                            // Get the selected location text from the controller
                            String selectedLocationText = Get.find<FilterController>().getSelectedLocationText();
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
              return controller.category.value?.filter?.toLowerCase() == 'phone'
                  ? GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          isScrollControlled: true,
                          MultiFilterBottomSheet(
                            title: localLanguage.mobile_brand,
                            data: controller.mobileBrand,
                            selectedData: controller.selectMobileBrand,
                          ),
                        ).then((_) {
                          controller.selectMobileBrand.refresh();
                        });
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    localLanguage.brand,
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
                                              controller.selectMobileBrand.isEmpty
                                                  ? localLanguage.not_chosen_yet
                                                  : controller.selectMobileBrand
                                                      .expand((e) => [e.toString()])
                                                      .join(', '),
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
                    )
                  : SizedBox();
            }),
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
                      localLanguage.account_type,
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
                                      controller.accountType.value == "" ? Colors.white : Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  controller.accountType.value = "";
                                },
                                child: Text(
                                  localLanguage.all,
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
                                          controller.accountType.value == "Premium" ? Colors.white : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.accountType.value = "Premium";
                                  },
                                  child: Text(
                                    localLanguage.premium,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Obx(() => ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: controller.accountType.value == "Ordinary"
                                          ? Colors.white
                                          : Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                                  onPressed: () {
                                    controller.accountType.value = "Ordinary";
                                  },
                                  child: Text(
                                    localLanguage.ordinary,
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
                      localLanguage.price,
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
                            hintText: localLanguage.from,
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
                            hintText: localLanguage.to,
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
            child: Obx(
              () {
                return controller.category.value?.name?.toLowerCase() == 'cars' ||
                        controller.category.value?.name?.toLowerCase() == "foreign cars"
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //*Brand Section
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                isScrollControlled: true,
                                CarMultiBrandBottomSheet(
                                  title: localLanguage.brand,
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
                                        localLanguage.brand,
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
                                                  margin: EdgeInsets.only(right: 4.w),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 2.h,
                                                  ),
                                                  child: Text(
                                                    localLanguage.choose_brand,
                                                    style: medium.copyWith(
                                                      fontSize: 10.sp,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                )
                                              : ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  children: controller.brand.map((brand) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.textFieldGray,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0.r),
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(right: 4.w),
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 2.h,
                                                        horizontal: 4.w,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          brand.brand ?? localLanguage.choose_brand,
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
                                      var brand = controller.brandAndSelectedModel[index];
                                      return SizedBox(
                                        width: (Get.width / (controller.brand.length > 1 ? 2 : 1)) - 26.w,
                                        child: FilterOptionWidget(
                                          title: localLanguage.model,
                                          titleSub: '*(${brand['brand'].brand ?? ''})',
                                          subTitle: controller.brandAndSelectedModel[index]['model'].isEmpty
                                              ? localLanguage.not_chosen_yet
                                              : '${controller.brandAndSelectedModel[index]['model'].toList().expand((e) => [
                                                    e.name.toString()
                                                  ]).join(', ')}',
                                          onTap: () {
                                            Get.bottomSheet(
                                              CarMultiModelBottomSheet(
                                                title: localLanguage.model,
                                                data: (brand['brand'].model ?? <CarModel>[]).toList(),
                                                selectedData: controller.brandAndSelectedModel[index]['model'],
                                                onSelect: (p0) {
                                                  controller.brandAndSelectedModel[index]['model'] = p0;
                                                  controller.brandAndSelectedModel.refresh();
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
                                        title: localLanguage.body_type,
                                        subTitle: controller.bodyType.value,
                                        onTap: () {
                                          Get.bottomSheet(
                                            FilterBottomSheet(
                                              title: localLanguage.body_type,
                                              data: controller.dBodyType,
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
                                      title: localLanguage.drive_type,
                                      subTitle: controller.driveType.value,
                                      onTap: () {
                                        Get.bottomSheet(
                                          FilterBottomSheet(
                                            title: localLanguage.drive_type,
                                            data: controller.dDriveType,
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
                                      title: localLanguage.engine_type,
                                      subTitle: controller.engineType.value,
                                      onTap: () {
                                        Get.bottomSheet(
                                          FilterBottomSheet(
                                            title: localLanguage.engine_type,
                                            data: controller.dEngineType,
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
                                        title: localLanguage.transmission,
                                        subTitle: controller.transmission.value,
                                        onTap: () {
                                          Get.bottomSheet(
                                            FilterBottomSheet(
                                              title: localLanguage.transmission,
                                              data: controller.dTransmission,
                                              selectedData: controller.transmission,
                                            ),
                                          );
                                        },
                                      )),
                                ),
                                10.horizontalSpace,
                                const Expanded(
                                  child: FilterYearRangePicker(),
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
                                      title: localLanguage.color,
                                      subTitle: controller.color.isEmpty
                                          ? localLanguage.not_chosen_yet
                                          : controller.color.expand((e) => [e.toString()]).join(', '),
                                      onTap: () {
                                        Get.bottomSheet(
                                          ColorPickerSheet(
                                            title: localLanguage.color,
                                            data: controller.dColor,
                                            selectedData: controller.color,
                                          ),
                                        ).then((_) {
                                          controller.color.refresh();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // 10.horizontalSpace,
                                // const Expanded(
                                //   child: MileagePicker(),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (controller.category.value?.filter?.toLowerCase().contains("real_estate") ?? false)
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h, bottom: 10.h),
                            child: Column(
                              children: [
                                if (controller.category.value?.filter != "real_estate_2")
                                  //Estate Type
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                                    child: FormBuilderDropdown<String>(
                                      name: 'estateType',
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),
                                      onChanged: (newValue) {
                                        controller.dEstateType.value = newValue!;
                                      },
                                      style: regular.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              localLanguage.estate_type,
                                              style: bold.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            10.horizontalSpace,
                                          ],
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                      ),
                                      selectedItemBuilder: (context) {
                                        return controller.dEstateTypeList
                                            .map(
                                              (estate) => DropdownMenuItem<String>(
                                                alignment: Alignment.centerRight,
                                                value: estate,
                                                child: Text(
                                                  estate,
                                                  style: regular.copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList();
                                      },
                                      items: controller.dEstateTypeList
                                          .map(
                                            (estate) => DropdownMenuItem<String>(
                                              value: estate,
                                              child: Text(
                                                estate,
                                                style: regular.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                if (controller.category.value?.filter != "real_estate_2")
                                  //Renovation Type
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                                    child: FormBuilderDropdown<String>(
                                      name: 'estateDealType',
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),
                                      onChanged: (newValue) {
                                        controller.dEstateRenovType.value = newValue!;
                                      },
                                      style: regular.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              localLanguage.deal_type,
                                              style: bold.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            10.horizontalSpace,
                                          ],
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: context.theme.shadowColor.withOpacity(.3),
                                          ),
                                        ),
                                      ),
                                      selectedItemBuilder: (context) {
                                        return controller.dEstateRenovTypeList
                                            .map(
                                              (estate) => DropdownMenuItem<String>(
                                                alignment: Alignment.centerRight,
                                                value: estate,
                                                child: Text(
                                                  estate,
                                                  style: regular.copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList();
                                      },
                                      items: controller.dEstateRenovTypeList
                                          .map(
                                            (estate) => DropdownMenuItem<String>(
                                              value: estate,
                                              child: Text(
                                                estate,
                                                style: regular.copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                //Floor and Room
                                Row(
                                  children: [
                                    //Floor
                                    Expanded(
                                      child: Obx(
                                        () => _tile(
                                          localLanguage.floor,
                                          controller.selectedFloor.value,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => SingleDialogPicker(
                                                title: localLanguage.select_number_of_floor,
                                                items: List.generate(
                                                  15,
                                                  (index) => (index + 1).toString(),
                                                ),
                                                selectYear: controller.selectedFloor,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    //Room
                                    if ((controller.category.value?.filter?.toLowerCase() != "real_estate_2"))
                                      Expanded(
                                        child: Obx(
                                          () => _tile(
                                            localLanguage.room,
                                            controller.selectedFloor.value,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => SingleDialogPicker(
                                                  title: localLanguage.select_number_of_room,
                                                  items: List.generate(
                                                    10,
                                                    (index) => (index + 1).toString(),
                                                  ),
                                                  selectYear: controller.selectedFloor,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (controller.category.value?.filter != "real_estate_2")
                                  //Lift
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                    ).copyWith(bottom: 0, right: 5.w, top: 10.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                localLanguage.lift_available,
                                                style: bold.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: Obx(() {
                                                  return CupertinoSwitch(
                                                    value: controller.isLiftAvaiable.value,
                                                    onChanged: (value) {
                                                      controller.isLiftAvaiable.value = value;
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          )
                        : const Center();
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 20.h, left: 12.w),
              child: Column(
                children: [
                  Obx(() {
                    return controller.category.value?.filter?.toLowerCase() == 'car' ||
                            controller.category.value?.filter?.toLowerCase() == 'phone'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  localLanguage.credit,
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
                          )
                        : SizedBox();
                  }),
                  10.verticalSpace,
                  Obx(() {
                    return controller.category.value?.filter?.toLowerCase() == 'car' ||
                            controller.category.value?.filter?.toLowerCase() == 'phone'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  localLanguage.exchange,
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
                          )
                        : SizedBox();
                  }),
                  10.verticalSpace,
                  Obx(() {
                    return controller.category.value?.filter?.toLowerCase() == 'car'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  localLanguage.has_a_vin_code,
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
              child: SizedBox(
                height: 60.h,
                child: Obx(() {
                  return ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: controller.category.value == null ? AppColors.liteGray : AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: controller.category.value == null
                        ? null
                        : () {
                            controller.isFilterLoading.value = true;
                            controller.filterMapPassed = null;
                            controller.applyFilter();
                            if (widget.isBack) {
                              Get.back();
                            } else {
                              Get.to(const FilterResultsView(), transition: Transition.rightToLeft);
                            }
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
                      return Text(
                        localLanguage.filter,
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

  _tile(String title, String value, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: regular.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Not chosen yet' : value,
                    style: regular.copyWith(
                      fontSize: 14.sp,
                      fontWeight: value.isEmpty ? FontWeight.normal : FontWeight.w600,
                      color: value.isEmpty ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                height: 1,
                color: context.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

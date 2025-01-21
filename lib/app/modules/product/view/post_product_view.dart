import 'dart:convert';
import 'dart:developer';

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:video_editor/video_editor.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_snackbar.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/views/location_selection.dart';
import '../../filter/widgets/car_brand_sheet.dart';
import '../../filter/widgets/car_model_sheet.dart';
import '../../filter/widgets/color_picker_sheet.dart';
import '../../filter/widgets/engine_type_sheet.dart';
import '../../filter/widgets/filter_bottom_sheet.dart';
import '../controller/product_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../video_edit/crop_video.dart';
import '../widget/category_selection.dart';
import '../widget/post_category_selection.dart';

class PostProductView extends StatefulWidget {
  const PostProductView({super.key});

  @override
  State<PostProductView> createState() => _PostProductViewState();
}

class _PostProductViewState extends State<PostProductView> {
  ProductController productController = Get.find();
  AuthController authController = Get.find();
  HomeController homeController = Get.find();
  FilterController filterController = Get.find();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Get.theme.secondaryHeaderColor,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              6.verticalSpace,
              Row(
                children: [
                  Obx(() {
                    return Transform.scale(
                      scale: 1.3,
                      child: CupertinoCheckbox(
                        value: productController.checkTermsAndConditions.value,
                        onChanged: (value) {
                          productController.checkTermsAndConditions.value =
                              value!;
                        },
                      ),
                    );
                  }),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: regular.copyWith(
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(
                              text:
                                  'By Posting, you confirm the agreement with terms and conditions of'),
                          TextSpan(
                            text: ' Alsat',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              6.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            context.theme.primaryColor.withOpacity(.1),
                        side: BorderSide(
                          color: context.theme.primaryColor,
                          width: 1,
                        ),
                        fixedSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: regular.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        resetForm();
                      },
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    flex: 3,
                    child: Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size.fromHeight(48),
                          backgroundColor: context.theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: !productController
                                .checkTermsAndConditions.value
                            ? null
                            : productController.isProductPosting.value
                                ? null
                                : () async {
                                    _formKey.currentState!.saveAndValidate();
                                    if (_formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();

                                      if (productController.totalProductFiled.value != productController.totalProductFiledCount.value ||
                                          productController
                                                  .productPriceFiled.value !=
                                              productController
                                                  .productPriceFiledCount
                                                  .value ||
                                          productController
                                                  .individualInfoFiled.value !=
                                              productController
                                                  .individualInfoFiledCount
                                                  .value) {
                                        CustomSnackBar.showCustomToast(
                                            color: Colors.red,
                                            message:
                                                "Please fill all the fields");
                                      }
                                      if (productController
                                          .pickImageList.isEmpty) {
                                        CustomSnackBar.showCustomToast(
                                          color: Colors.red,
                                          message:
                                              "Please select at least one image",
                                        );
                                      } else {
                                        productController
                                            .isProductPosting.value = true;
                                        await addProductDataFormate(
                                            _formKey.currentState!.value);
                                      }
                                    }
                                  },
                        child: productController.isProductPosting.value
                            ? const CupertinoActivityIndicator()
                            : Text(
                                "Post",
                                style: regular.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      );
                    }),
                  )
                ],
              ),
              6.verticalSpace,
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Add Your Stuff',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                resetForm();
                _formKey.currentState!.reset();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              width: Get.width * .5,
                              height: Get.width > 600 ? 60.h : 40.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.theme.disabledColor
                                          .withOpacity(.1),
                                      offset: const Offset(0, 0),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: Obx(() {
                                return Stack(
                                  children: [
                                    AnimatedPositioned(
                                      height: Get.width > 600 ? 60.h : 30.h,
                                      duration: 300.ms,
                                      left: !productController
                                              .isShowPostProductVideo.value
                                          ? 0
                                          : Get.width * .22,
                                      child: Container(
                                        width: Get.width * .22,
                                        height: Get.width > 600 ? 60.h : 40.h,
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              productController
                                                  .isShowPostProductVideo
                                                  .value = false;
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Obx(() {
                                                return Text(
                                                  'Image',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: !productController
                                                            .isShowPostProductVideo
                                                            .value
                                                        ? Colors.white
                                                        : null,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              productController
                                                  .isShowPostProductVideo
                                                  .value = true;
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Obx(() {
                                                return Text(
                                                  'Video',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: productController
                                                            .isShowPostProductVideo
                                                            .value
                                                        ? Colors.white
                                                        : null,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                        // information
                        /// Post Product Video
                        Obx(() {
                          return !productController.isShowPostProductVideo.value
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 15.h,
                                  ),
                                  height: 100.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        // Allows flexible width to avoid overflow
                                        child: SizedBox(
                                          height: 100.h,
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                  productController
                                                      .pickImageList.length,
                                                  (index) {
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      7.w),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              15.r,
                                                            ),
                                                            child: Image.file(
                                                              productController
                                                                      .pickImageList[
                                                                  index],
                                                              fit: BoxFit.cover,
                                                              width: 70.w,
                                                              height: 70.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: -10.h,
                                                          right: 0,
                                                          left: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              productController
                                                                  .pickImageList
                                                                  .removeAt(
                                                                      index);
                                                            },
                                                            child: Image.asset(
                                                              xmarkIcon,
                                                              height: 25.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      GestureDetector(
                                        onTap: () {
                                          productController.pickImage(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 70.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            border: Border.all(
                                              width: 1,
                                              color: context.theme.disabledColor
                                                  .withOpacity(.4),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.add,
                                                size: 20.sp,
                                                color: context
                                                    .theme.disabledColor
                                                    .withOpacity(.4),
                                              ),
                                              Text(
                                                "Add",
                                                style: regular.copyWith(
                                                  color: context
                                                      .theme.disabledColor
                                                      .withOpacity(.4),
                                                  fontSize: 12.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 15.h,
                                  ),
                                  height: 100.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        // Allows flexible width to avoid overflow
                                        child: SizedBox(
                                          height: 100.h,
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                  productController
                                                      .videoThumbnails.length,
                                                  (index) {
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      7.w),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              15.r,
                                                            ),
                                                            child: Image.memory(
                                                              productController
                                                                      .videoThumbnails[
                                                                  index]!,
                                                              fit: BoxFit.cover,
                                                              width: 70.w,
                                                              height: 70.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          size: 25.r,
                                                          color: Colors.red,
                                                        ),
                                                        Positioned(
                                                          bottom: -10.h,
                                                          right: 0,
                                                          left: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              productController
                                                                  .videoThumbnails
                                                                  .removeAt(
                                                                      index);
                                                              productController
                                                                  .pickVideoList
                                                                  .removeAt(
                                                                      index);
                                                            },
                                                            child: Image.asset(
                                                              xmarkIcon,
                                                              height: 25.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      GestureDetector(
                                        onTap: () {
                                          productController
                                              .pickVideo(context)
                                              .then((onValue) {
                                            log("Call To Pick Video");
                                            if (productController
                                                    .pickVideoFile !=
                                                null) {
                                              Get.to(VideoCropScreen(
                                                  productController
                                                      .pickVideoFile!));
                                            }
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 70.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            border: Border.all(
                                              width: 1,
                                              color: context.theme.disabledColor
                                                  .withOpacity(.4),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.add,
                                                size: 20.sp,
                                                color: context
                                                    .theme.disabledColor
                                                    .withOpacity(.4),
                                              ),
                                              Text(
                                                "Add",
                                                style: regular.copyWith(
                                                  color: context
                                                      .theme.disabledColor
                                                      .withOpacity(.4),
                                                  fontSize: 12.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }),

                        ExpansionTile(
                          initiallyExpanded: true,
                          iconColor: context.theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.primaryColor.withOpacity(.7),
                              width: .7,
                            ),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.primaryColor.withOpacity(.7),
                              width: .7,
                            ),
                          ),
                          leading: Padding(
                            padding: EdgeInsets.all(5.w).copyWith(right: 0),
                            child: Obx(() {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: productController
                                            .totalProductFiledCount.value /
                                        productController
                                            .totalProductFiled.value,
                                    strokeAlign: .1,
                                    strokeWidth: 2,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                  if (productController
                                          .totalProductFiledCount.value ==
                                      productController.totalProductFiled.value)
                                    Icon(
                                      Icons.check,
                                      size: 30.r,
                                      color: context.theme.primaryColor,
                                    )
                                ],
                              );
                            }),
                          ),
                          subtitle: Obx(() {
                            return Text(
                              '${productController.totalProductFiledCount.value}/${productController.totalProductFiled.value} filled',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            'Product',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            Divider(
                              color: context.theme.primaryColor,
                              height: 1,
                            ),
                            Obx(() => _tile(
                                  "Category",
                                  productController
                                          .selectCategory.value?.name ??
                                      "Not choosen yet",
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          const PostCategorySelection(),
                                    ).then((_) {
                                      productController
                                          .calculateFilledProductFields();
                                    });
                                  },
                                )),
                            Obx(() => productController
                                        .selectSubCategory.value?.name ==
                                    null
                                ? const Center()
                                : _tile(
                                    "Sub Category",
                                    productController
                                            .selectSubCategory.value?.name ??
                                        "Not choosen yet",
                                    onTap: () {
                                      showCupertinoModalBottomSheet(
                                        expand: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            const PostCategorySelection(),
                                      ).then((_) {
                                        productController
                                            .calculateFilledProductFields();
                                      });
                                    },
                                  )),
                            Obx(() => productController
                                        .selectCategory.value?.name
                                        ?.toLowerCase() ==
                                    'automobile'
                                ? _autoMobile(context)
                                : productController.selectCategory.value?.name
                                            ?.toLowerCase() ==
                                        'real estate'
                                    ? _realEstate(context)
                                    : productController
                                                .selectCategory.value?.name
                                                ?.toLowerCase() ==
                                            'phone'
                                        ? _phoneCategory(context)
                                        : const Center()),
                            //product Name
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                name: 'productName',
                                onChanged: (newValue) {
                                  productController
                                      .calculateFilledProductFields();
                                },
                                controller:
                                    productController.productNameController,
                                textAlign: TextAlign.right,
                                textAlignVertical: TextAlignVertical.center,
                                style: regular.copyWith(
                                  // fontSize: 12.sp,
                                  color: context.theme.primaryColor,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Product Name',
                                        style: bold.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: context.theme.primaryColor,
                                        ),
                                      ),
                                      10.horizontalSpace,
                                    ],
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // product discription
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Description',
                                    style: bold.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  FormBuilderTextField(
                                    controller: productController
                                        .productDescriptionController,
                                    onChanged: (newValue) {
                                      productController
                                          .calculateFilledProductFields();
                                    },
                                    minLines: 3,
                                    maxLines: 3,
                                    name: 'discription',
                                    style: regular.copyWith(
                                      color: context.theme.primaryColor,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Describe your product',
                                      hintStyle: regular.copyWith(
                                        color: context.theme.disabledColor,
                                      ),
                                      border: outlineBorder,
                                      enabledBorder: outlineBorder,
                                      errorBorder: outlineBorder,
                                      focusedBorder: outlineBorder,
                                    ),
                                  ),
                                  Obx(() {
                                    return productController
                                                .selectCategory.value?.name
                                                ?.toLowerCase() ==
                                            'automobile'
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'VIN code',
                                                  style: bold,
                                                ),
                                                10.horizontalSpace,
                                                Expanded(
                                                    child: FormBuilderTextField(
                                                  controller:
                                                      productController.vinCode,
                                                  name: 'vinCode',
                                                  onChanged: (newValue) {
                                                    productController
                                                        .calculateFilledProductFields();
                                                  },
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Get
                                                        .theme.primaryColor
                                                        .withOpacity(.6),
                                                  ),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    alignLabelWithHint: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    labelText: '',
                                                    labelStyle: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Get
                                                          .theme.primaryColor
                                                          .withOpacity(.6),
                                                    ),
                                                    border:
                                                        outlineBorderPrimary,
                                                    enabledBorder:
                                                        outlineBorderPrimary,
                                                    errorBorder:
                                                        outlineBorderPrimary,
                                                    focusedBorder:
                                                        outlineBorderPrimary,
                                                  ),
                                                ))
                                              ],
                                            ),
                                          )
                                        : const Center();
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,

                        ///Price
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          initiallyExpanded: true,
                          iconColor: context.theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.shadowColor.withOpacity(.4),
                              width: .7,
                            ),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.shadowColor.withOpacity(.4),
                              width: .7,
                            ),
                          ),
                          leading: Obx(() {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: productController
                                          .productPriceFiledCount.value /
                                      productController.productPriceFiled.value,
                                  strokeAlign: .1,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: productController
                                              .productPriceFiledCount.value ==
                                          productController
                                              .productPriceFiled.value
                                      ? Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: Theme.of(context).primaryColor,
                                          key: const ValueKey('checked'),
                                        ).animate().fadeIn(duration: 300.ms)
                                      : const SizedBox
                                          .shrink(), // Empty widget when not checked
                                ),
                              ],
                            );
                          }),
                          subtitle: Obx(() {
                            return Text(
                              '${productController.productPriceFiledCount.value}/${productController.productPriceFiled.value} filled',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            'Price',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                onChanged: (value) {
                                  if ((value ?? '').isEmpty) {
                                    productController
                                        .productPriceFiledCount.value = 2;
                                  } else {
                                    productController
                                        .productPriceFiledCount.value = 3;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                name: 'price',
                                controller: productController.priceController,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    width: 70.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Price, \$',
                                      style: regular,
                                    ),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Possible Exchange',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value:
                                            productController.isExchange.value,
                                        onChanged: (value) {
                                          productController.isExchange.value =
                                              value;
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Credit',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController.isCredit.value,
                                        onChanged: (value) {
                                          productController.isCredit.value =
                                              value;
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                          ],
                        ),
                        10.verticalSpace,
                        //Individual info
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          initiallyExpanded: true,
                          iconColor: context.theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.shadowColor.withOpacity(.4),
                              width: .7,
                            ),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: context.theme.shadowColor.withOpacity(.4),
                              width: .7,
                            ),
                          ),
                          leading: Obx(() {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: productController
                                          .individualInfoFiledCount.value /
                                      productController
                                          .individualInfoFiled.value,
                                  strokeAlign: .1,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: productController
                                              .individualInfoFiledCount.value ==
                                          productController
                                              .individualInfoFiled.value
                                      ? Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: Theme.of(context).primaryColor,
                                          key: const ValueKey('checked'),
                                        ).animate().fadeIn(duration: 300.ms)
                                      : const SizedBox
                                          .shrink(), // Empty widget when not checked
                                ),
                              ],
                            );
                          }),
                          subtitle: Obx(() {
                            return Text(
                              '${productController.individualInfoFiledCount.value}/${productController.individualInfoFiled.value} filled',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            'Individual Info',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            CupertinoListTile(
                              onTap: () {
                                showCupertinoModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => const LocationSelection(
                                      canSelectMultiple: false),
                                );
                              },
                              subtitle: Obx(() {
                                return Text(
                                  Get.find<FilterController>()
                                      .getSelectedLocationText(),
                                  style: regular.copyWith(
                                    fontSize: 10.sp,
                                    color: context.theme.primaryColor,
                                  ),
                                );
                              }),
                              title: Text(
                                "Location",
                                style: regular,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.r,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Divider(
                                height: 1,
                                color:
                                    context.theme.shadowColor.withOpacity(.4),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                onChanged: (value) {
                                  productController
                                      .calculateFilledIndividualInfoFields();
                                },
                                name: 'phoneNumber',
                                enabled: false,
                                initialValue:
                                    "${authController.userDataModel.value.phone}",
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.theme.shadowColor
                                          .withOpacity(.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //time picker
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'When I Am Free To Call',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            productController
                                                .showUserTimePickerDialog(
                                                    context)
                                                .then((value) {
                                              productController.fromTime.value =
                                                  value;
                                              productController
                                                  .calculateFilledIndividualInfoFields();
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              productController
                                                          .fromTime.value ==
                                                      null
                                                  ? "From N/A"
                                                  : 'From ${productController.fromTime.value?.hour ?? '00'}:${productController.fromTime.value?.minute ?? '00'}',
                                              style: regular,
                                            );
                                          }),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            productController
                                                .showUserTimePickerDialog(
                                                    context)
                                                .then((value) {
                                              productController.toTime.value =
                                                  value;
                                              productController
                                                  .calculateFilledIndividualInfoFields();
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              productController.toTime.value ==
                                                      null
                                                  ? "TO N/A"
                                                  : 'To ${productController.toTime.value?.hour ?? '00'}:${productController.toTime.value?.minute ?? '00'}',
                                              style: regular,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    child: Divider(
                                      height: 1,
                                      color: context.theme.shadowColor
                                          .withOpacity(.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Allow me to call',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value:
                                            productController.allowCall.value,
                                        onChanged: (value) {
                                          productController.allowCall.value =
                                              value;
                                          if (!productController
                                                  .allowCall.value &&
                                              !productController
                                                  .contactOnlyWithChat.value) {
                                            productController
                                                .contactOnlyWithChat
                                                .value = true;
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Contact only in chat',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController
                                            .contactOnlyWithChat.value,
                                        onChanged: (value) {
                                          productController.contactOnlyWithChat
                                              .value = value;
                                          if (!productController
                                                  .allowCall.value &&
                                              !productController
                                                  .contactOnlyWithChat.value) {
                                            productController.allowCall.value =
                                                true;
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _realEstate(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: FormBuilderTextField(
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'estateType',
            onChanged: (newValue) {
              productController.calculateFilledProductFields();
            },
            controller: productController.estateTypeController,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            style: regular.copyWith(
              // fontSize: 12.sp,
              color: context.theme.primaryColor,
            ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Estate type',
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: FormBuilderTextField(
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'estateAddress',
            onChanged: (newValue) {
              productController.calculateFilledProductFields();
            },
            controller: productController.estateAddressController,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            style: regular.copyWith(
              // fontSize: 12.sp,
              color: context.theme.primaryColor,
            ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Address',
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: FormBuilderTextField(
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'estateDealType',
            onChanged: (newValue) {
              productController.calculateFilledProductFields();
            },
            controller: productController.estateDealTypeController,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            style: regular.copyWith(
              // fontSize: 12.sp,
              color: context.theme.primaryColor,
            ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Deal type',
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
          ),
        ),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: Row(
            children: [
              Text(
                'Floor',
                style: bold.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: FormBuilderTextField(
                  controller: productController.floor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  name: 'floor',
                  onChanged: (newValue) {
                    productController.calculateFilledProductFields();
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Get.theme.primaryColor.withOpacity(.6),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: '',
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Get.theme.primaryColor.withOpacity(.6),
                    ),
                    border: outlineBorderPrimary,
                    enabledBorder: outlineBorderPrimary,
                    errorBorder: outlineBorderPrimary,
                    focusedBorder: outlineBorderPrimary,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              30.horizontalSpace,
              Text(
                'Room',
                style: bold.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: FormBuilderTextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  controller: productController.room,
                  name: 'room',
                  onChanged: (newValue) {
                    productController.calculateFilledProductFields();
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Get.theme.primaryColor.withOpacity(.6),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    isDense: true,
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: '',
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Get.theme.primaryColor.withOpacity(.6),
                    ),
                    border: outlineBorderPrimary,
                    enabledBorder: outlineBorderPrimary,
                    errorBorder: outlineBorderPrimary,
                    focusedBorder: outlineBorderPrimary,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h)
              .copyWith(bottom: 0, right: 5.w),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lift Available',
                      style: bold.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Obx(() {
                        return CupertinoSwitch(
                          value: productController.isLeftAvalable.value,
                          onChanged: (value) {
                            productController.isLeftAvalable.value = value;
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
    );
  }

  Widget _phoneCategory(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => _tile(
            "Brand",
            productController.selectedPhoneBrand.value,
            onTap: () {
              Get.bottomSheet(
                isScrollControlled: true,
                FilterBottomSheet(
                  title: "Brand",
                  data: filterController.mobileBrand,
                  selectedData: productController.selectedPhoneBrand,
                ),
              ).then((_) {
                productController.calculateFilledProductFields();
              });
            },
          ),
        ),
      ],
    );
  }

  Column _autoMobile(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          return productController.selectCategory.value == null
              ? const Center()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => _tile(
                        "Brand",
                        productController.selectedBrand.value?.brand ?? '',
                        onTap: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            CarBrandBottomSheet(
                              title: "Brand",
                              data: homeController.brandList,
                              selectedData: productController.selectedBrand,
                            ),
                          ).then((_) {
                            productController.calculateFilledProductFields();
                          });
                        },
                      ),
                    ),
                    Obx(() => _tile(
                          "Model",
                          productController.selectedModel.value?.name ?? '',
                          onTap:
                              (productController.selectedBrand.value?.model ??
                                          [])
                                      .isEmpty
                                  ? null
                                  : () {
                                      Get.bottomSheet(
                                        CarModelBottomSheet(
                                          title: "Model",
                                          data: productController
                                              .selectedBrand.value!.model!,
                                          selectedData:
                                              productController.selectedModel,
                                        ),
                                      ).then((_) {
                                        productController.selectModelCarClass
                                            .value = productController
                                                .selectedModel
                                                .value
                                                ?.modelClass ??
                                            [];

                                        productController
                                            .calculateFilledProductFields();
                                      });
                                    },
                        )),
                    Obx(() => _tile(
                          "Body Type",
                          productController.selectedBodyType.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Body Type",
                                data: productController.selectModelCarClass,
                                selectedData:
                                    productController.selectedBodyType,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          "Transmission",
                          productController.selectedTransmission.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Transmission",
                                data: filterController.dtransmission,
                                selectedData:
                                    productController.selectedTransmission,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          "Engine Type",
                          productController.selectedEngineType.value,
                          onTap: () {
                            Get.bottomSheet(
                              EngineTypeSheet(
                                title: "Engine Type",
                                data: filterController.dengineType,
                                selectedData:
                                    productController.selectedEngineType,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          "Passed, km",
                          productController.selectedPassed.value,
                          onTap: () {
                            Get.bottomSheet(
                              EngineTypeSheet(
                                title: "Passed, km",
                                data: RxList.generate(
                                    200, (index) => (index * 100).toString()),
                                selectedData: productController.selectedPassed,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(
                      () => _tile(
                        "Year",
                        productController.selectedYear.value,
                        onTap: () {},
                      ),
                    ),
                    Obx(() => _tile(
                          "Color",
                          productController.selectedColor.value.firstOrNull ??
                              '',
                          onTap: () {
                            productController.selectedColor.clear();
                            Get.bottomSheet(
                              isScrollControlled: true,
                              ColorPickerSheet(
                                title: "Color",
                                data: filterController.dcolor,
                                isMulti: false,
                                selectedData: productController.selectedColor,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                  ],
                );
        }),
      ],
    );
  }

  Future<void> addProductDataFormate(Map<String, dynamic> map) async {
    Map<String, dynamic> productPostMap = {};
    productPostMap['title'] = map['productName'];
    productPostMap['type'] =
        productController.selectCategory.value?.name?.toLowerCase() ==
                'automobile'
            ? 'car'
            : productController.selectCategory.value?.name?.toLowerCase() ==
                    'real estate'
                ? "real_estate"
                : productController.selectCategory.value?.name?.toLowerCase() ==
                        'phone'
                    ? 'phone'
                    : 'general';
    productPostMap['category_id'] = productController.selectCategory.value?.sId;
    productPostMap['description'] = map['discription'];

    List<Map> media = [];
    for (var image in productController.pickImageList.value) {
      var mediaDataTemp = await imageToBase64(image.path);
      media.add(mediaDataTemp);
    }
    for (var video in productController.pickVideoList.value) {
      var mediaDataTemp = await videoToBase64(video.path);
      media.add(mediaDataTemp);
    }
    productPostMap['media'] = media;

    productPostMap['individual_info'] = {
      "location_province": filterController.selectedProvince.value,
      "location_city": filterController.selectedCity.value,
      //demo
      "location_geo": {
        "type": "Point", // point
        "coordinates": [10, -10]
      },
      "phone_number": map['phoneNumber'],
      "free_to_call_from":
          "${productController.fromTime.value?.hour}:${productController.fromTime.value?.minute}",
      "free_to_call_to":
          '${productController.toTime.value?.hour}:${productController.toTime.value?.minute}',
      "allow_to_call": productController.allowCall.value,
      "contact_only_in_chat": productController.contactOnlyWithChat.value,
      "can_comment": true
    };
    productPostMap['price_info'] = {
      'price': num.parse(map['price']).toDouble(),
      "possible_exchange": productController.isExchange.value,
      "credit": productController.isCredit.value,
    };
    productPostMap['car_info'] =
        productController.selectCategory.value?.name?.toLowerCase() ==
                'automobile'
            ? {
                "condition": map['condition'],
                "brand": productController.selectedBrand.value?.brand,
                "model": productController.selectedModel.value?.name,
                "class": productController.selectedBodyType.value,
                "body_type": productController.selectedBodyType.value,
                "transmission": productController.selectedTransmission.value,
                "engine_type": productController.selectedEngineType.value,
                "passed_km":
                    num.parse(productController.selectedPassed.value).toInt(),
                "year": num.parse(productController.selectedYear.value).toInt(),
                "color": productController.selectedColor.first,
                "vin_code": map['vinCode'],
              }
            : null;
    productPostMap['estate_info'] =
        productController.selectCategory.value?.name?.toLowerCase() ==
                'real estate'
            ? {
                "type": map['estateType'],
                "address": map['estateAddress'],
                "deal_type": map['estateDealType'],
                "floor": num.parse(map['floor']).toInt(),
                "floor_type": 2,
                "room": num.parse(map['room']).toInt(),
                "renov": "cosmetique",
                "lift": productController.isLeftAvalable.value,
              }
            : null;
    productPostMap['phone_info'] =
        productController.selectCategory.value?.name?.toLowerCase() == 'phone'
            ? {"brand": productController.selectedPhoneBrand.value}
            : null;
    resetForm();
    _formKey.currentState!.reset();
    await productController.postProduct(productPostMap);
  }

  resetForm() {
    _formKey.currentState?.reset();
    productController.estateDealTypeController.clear();
    productController.estateAddressController.clear();
    productController.estateTypeController.clear();
    productController.selectedPhoneBrand.value = '';
    productController.productNameController.clear();
    productController.productDescriptionController.clear();
    productController.vinCode.clear();
    productController.floor.clear();
    productController.priceController.clear();
    productController.room.clear();

    productController.pickImageList.clear();
    productController.selectCategory.value = null;
    productController.selectSubCategory.value = null;
    productController.selectedBrand.value = null;
    productController.selectedModel.value = null;
    productController.selectedBodyType.value = '';
    productController.selectedTransmission.value = '';
    productController.selectedEngineType.value = '';
    productController.selectedColor.value = [];
    productController.fromTime.value = null;
    productController.toTime.value = null;
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
                      fontWeight:
                          value.isEmpty ? FontWeight.normal : FontWeight.w600,
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

// ignore_for_file: deprecated_member_use

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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../../../config/translations/localization_controller.dart';
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

import '../widget/post_category_selection.dart';
import '../widget/single_year_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    filterController.clearAddress();
    Future.microtask(() {
      filterController.selectedProvince.value = authController.userDataModel.value.location?.province ?? "";
      filterController.selectedCity.value = authController.userDataModel.value.location?.city ?? "";
      productController.calculateFilledIndividualInfoFields();
      productController.calculateFilledProductFields();
    });
    super.initState();
  }

  @override
  void dispose() {
    filterController.clearAddress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return FormBuilder(
      key: productController.postKey,
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
                          productController.checkTermsAndConditions.value = value!;
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
                        children: [
                          TextSpan(
                            text: localLanguage.by_posting_you_confirm,
                          ),
                          TextSpan(
                            text: ' Teklip',
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
                        backgroundColor: context.theme.primaryColor.withOpacity(.1),
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
                        localLanguage.cancel,
                        style: regular.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        productController.resetForm();
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
                        onPressed: !productController.checkTermsAndConditions.value
                            ? null
                            : productController.isProductPosting.value
                                ? null
                                : () async {
                                    productController.postKey.currentState!.saveAndValidate();
                                    if (productController.postKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();

                                      if (productController.pickImageList.isEmpty) {
                                        CustomSnackBar.showCustomToast(
                                          color: Colors.red,
                                          message: localLanguage.at_least_one_image,
                                        );
                                      } else if (productController.individualInfoFiledCount.value !=
                                          productController.individualInfoFiled.value) {
                                        CustomSnackBar.showCustomToast(
                                          color: Colors.red,
                                          message: localLanguage.please_select_all_required_fields,
                                        );
                                      } else {
                                        await addProductDataFormate(productController.postKey.currentState!.value);
                                      }
                                    }
                                  },
                        child: productController.isProductPosting.value
                            ? const CupertinoActivityIndicator()
                            : Text(
                                localLanguage.post,
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
            localLanguage.add_your_stuff,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                productController.resetForm();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 18.r,
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
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              width: Get.width * .6,
                              height: Get.width > 600 ? 60.h : 40.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.theme.disabledColor.withOpacity(.1),
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
                                      left: !productController.isShowPostProductVideo.value ? 0 : Get.width * .27,
                                      child: Container(
                                        width: Get.width * .27,
                                        height: Get.width > 600 ? 60.h : 40.h,
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              productController.isShowPostProductVideo.value = false;
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Obx(() {
                                                return Text(
                                                  localLanguage.image,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: !productController.isShowPostProductVideo.value
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
                                              productController.isShowPostProductVideo.value = true;
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Obx(() {
                                                return Text(
                                                  localLanguage.video,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: productController.isShowPostProductVideo.value
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
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                  productController.pickImageList.length,
                                                  (index) {
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(
                                                              15.r,
                                                            ),
                                                            child: Image.file(
                                                              productController.pickImageList[index],
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
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              productController.pickImageList.removeAt(index);
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
                                            borderRadius: BorderRadius.circular(15.r),
                                            border: Border.all(
                                              width: 1,
                                              color: context.theme.disabledColor.withOpacity(.4),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.add,
                                                size: 20.sp,
                                                color: context.theme.disabledColor.withOpacity(.4),
                                              ),
                                              Text(
                                                localLanguage.add,
                                                style: regular.copyWith(
                                                  color: context.theme.disabledColor.withOpacity(.4),
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
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                  productController.videoThumbnails.length,
                                                  (index) {
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(
                                                              15.r,
                                                            ),
                                                            child: Image.memory(
                                                              productController.videoThumbnails[index]!,
                                                              fit: BoxFit.cover,
                                                              width: 70.w,
                                                              height: 70.h,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.play_arrow_rounded,
                                                          size: 25.r,
                                                          color: Colors.red,
                                                        ),
                                                        Positioned(
                                                          bottom: -10.h,
                                                          right: 0,
                                                          left: 0,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              productController.videoThumbnails.removeAt(index);
                                                              productController.pickVideoList.removeAt(index);
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
                                          productController.pickVideo(context).then((onValue) {
                                            log("Call To Pick Video");
                                            if (productController.pickVideoFile != null) {
                                              Get.to(VideoCropScreen(productController.pickVideoFile!));
                                            }
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 70.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.r),
                                            border: Border.all(
                                              width: 1,
                                              color: context.theme.disabledColor.withOpacity(.4),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.add,
                                                size: 20.sp,
                                                color: context.theme.disabledColor.withOpacity(.4),
                                              ),
                                              Text(
                                                localLanguage.add,
                                                style: regular.copyWith(
                                                  color: context.theme.disabledColor.withOpacity(.4),
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
                                    value: productController.totalProductFiledCount.value /
                                        productController.totalProductFiled.value,
                                    strokeAlign: .1,
                                    strokeWidth: 2,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                  if (productController.totalProductFiledCount.value ==
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
                              '${productController.totalProductFiledCount.value}/${productController.totalProductFiled.value} ${localLanguage.filled}',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            localLanguage.product,
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
                                  localLanguage.category,
                                  productController.selectCategory.value?.name ?? localLanguage.not_chosen_yet,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const PostCategorySelection(),
                                    ).then((_) {
                                      productController.calculateFilledProductFields();
                                    });
                                  },
                                )),
                            Obx(() => productController.selectSubCategory.value?.name == null
                                ? const Center()
                                : _tile(
                                    localLanguage.sub_category,
                                    productController.selectSubCategory.value?.name ?? localLanguage.not_chosen_yet,
                                    onTap: () {
                                      showCupertinoModalBottomSheet(
                                        expand: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const PostCategorySelection(),
                                      ).then((_) {
                                        productController.calculateFilledProductFields();
                                      });
                                    },
                                  )),
                            Obx(() => productController.selectCategory.value?.filter?.toLowerCase() == 'car' ||
                                    (productController.selectSubCategory.value?.filter ?? "").toLowerCase() == "car"
                                ? _autoMobile(context)
                                : (productController.selectCategory.value?.filter ?? '')
                                            .toLowerCase()
                                            .contains('real_estate') ||
                                        (productController.selectSubCategory.value?.filter ?? '')
                                            .toLowerCase()
                                            .contains('real_estate')
                                    ? _realEstate(context)
                                    : productController.selectCategory.value?.filter?.toLowerCase() == 'phone' ||
                                            productController.selectSubCategory.value?.filter?.toLowerCase() == 'phone'
                                        ? _phoneCategory(context)
                                        : const Center()),
                            //product Name
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                name: 'productName',
                                onChanged: (newValue) {
                                  productController.calculateFilledProductFields();
                                },
                                controller: productController.productNameController,
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                style: regular.copyWith(
                                    // fontSize: 12.sp,

                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        localLanguage.product_name,
                                        style: regular.copyWith(
                                          fontSize: 15.sp,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localLanguage.description,
                                    style: bold.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  FormBuilderTextField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: productController.productDescriptionController,
                                    onChanged: (newValue) {
                                      productController.calculateFilledProductFields();
                                    },
                                    minLines: 3,
                                    maxLines: 3,
                                    name: 'description',
                                    style: regular,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: localLanguage.describe_your_product,
                                      hintStyle: regular.copyWith(
                                        color: context.theme.disabledColor,
                                      ),
                                      border: outlineBorder,
                                      enabledBorder: outlineBorder,
                                      errorBorder: outlineBorder,
                                      focusedBorder: outlineBorder,
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  ),
                                  Obx(() {
                                    return productController.selectCategory.value?.filter?.toLowerCase() == 'car' ||
                                            (productController.selectSubCategory.value?.filter ?? "").toLowerCase() ==
                                                "car"
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  localLanguage.vin_code,
                                                  style: bold,
                                                ),
                                                10.horizontalSpace,
                                                Expanded(
                                                    child: FormBuilderTextField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  controller: productController.vinCode,
                                                  name: 'vinCode',
                                                  onChanged: (newValue) {},
                                                  textAlign: TextAlign.center,
                                                  style: medium,
                                                  decoration: InputDecoration(
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
                                  value: productController.productPriceFiledCount.value /
                                      productController.productPriceFiled.value,
                                  strokeAlign: .1,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: productController.productPriceFiledCount.value ==
                                          productController.productPriceFiled.value
                                      ? Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: Theme.of(context).primaryColor,
                                          key: const ValueKey('checked'),
                                        ).animate().fadeIn(duration: 300.ms)
                                      : const SizedBox.shrink(), // Empty widget when not checked
                                ),
                              ],
                            );
                          }),
                          subtitle: Obx(() {
                            return Text(
                              '${productController.productPriceFiledCount.value}/${productController.productPriceFiled.value} ${localLanguage.filled}',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            localLanguage.price,
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  if ((value ?? '').isEmpty) {
                                    productController.productPriceFiledCount.value = 2;
                                  } else {
                                    productController.productPriceFiledCount.value = 3;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                                name: 'price',
                                controller: productController.priceController,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    width: 70.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${localLanguage.price} : ',
                                      style: regular,
                                    ),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 12.sp,
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
                            Obx(() {
                              final selectedFilter = productController.selectSubCategory.value?.filter?.toLowerCase();
                              final isExceptionCategory = selectedFilter == 'car' || selectedFilter == 'phone';
                              return isExceptionCategory
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                localLanguage.possible_exchange,
                                                style: regular,
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: Obx(() {
                                                  return CupertinoSwitch(
                                                    value: productController.isExchange.value,
                                                    onChanged: (value) {
                                                      productController.isExchange.value = value;
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                localLanguage.credit,
                                                style: regular,
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: Obx(() {
                                                  return CupertinoSwitch(
                                                    value: productController.isCredit.value,
                                                    onChanged: (value) {
                                                      productController.isCredit.value = value;
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox();
                            }),
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
                                  value: productController.individualInfoFiledCount.value /
                                      productController.individualInfoFiled.value,
                                  strokeAlign: .1,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: productController.individualInfoFiledCount.value ==
                                          productController.individualInfoFiled.value
                                      ? Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: Theme.of(context).primaryColor,
                                          key: const ValueKey('checked'),
                                        ).animate().fadeIn(duration: 300.ms)
                                      : const SizedBox.shrink(), // Empty widget when not checked
                                ),
                              ],
                            );
                          }),
                          subtitle: Obx(() {
                            return Text(
                              '${productController.individualInfoFiledCount.value}/${productController.individualInfoFiled.value} ${localLanguage.filled}',
                              style: regular.copyWith(
                                fontSize: 10.sp,
                              ),
                            );
                          }),
                          title: Text(
                            localLanguage.individual_info,
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
                                  builder: (context) => const LocationSelection(canSelectMultiple: false),
                                );
                              },
                              subtitle: Obx(() {
                                return Text(
                                  Get.find<FilterController>().getSelectedLocationText(),
                                  style: bold.copyWith(
                                    fontSize: 14.sp,
                                    color: context.theme.primaryColor,
                                  ),
                                );
                              }),
                              title: Text(
                                localLanguage.location,
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
                                color: context.theme.shadowColor.withOpacity(.4),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                onChanged: (value) {
                                  productController.calculateFilledIndividualInfoFields();
                                },
                                name: 'phoneNumber',
                                enabled: false,
                                initialValue: "${authController.userDataModel.value.phone}",
                                decoration: InputDecoration(
                                  hintText: localLanguage.phone_number,
                                  hintStyle: TextStyle(
                                    fontSize: 12.sp,
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
                            //time picker
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localLanguage.when_i_am,
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
                                            productController.showUserTimePickerDialog(context).then((value) {
                                              productController.fromTime.value = value;
                                              productController.calculateFilledIndividualInfoFields();
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              productController.fromTime.value == null
                                                  ? localLanguage.from_na
                                                  //: '${localLanguage.from} ${productController.fromTime.value?.hour ?? '00'}:${productController.fromTime.value?.minute ?? '00'}',
                                                  : '${productController.fromTime.value?.hour ?? '00'}:${productController.fromTime.value?.minute ?? '00'}',
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
                                            productController.showUserTimePickerDialog(context).then((value) {
                                              productController.toTime.value = value;
                                              productController.calculateFilledIndividualInfoFields();
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              productController.toTime.value == null
                                                  ? localLanguage.to_na
                                                  : '${productController.toTime.value?.hour ?? '00'}:${productController.toTime.value?.minute ?? '00'}',
                                              style: regular,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Divider(
                                      height: 1,
                                      color: context.theme.shadowColor.withOpacity(.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localLanguage.allow_me_to_call,
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController.allowCall.value,
                                        onChanged: (value) {
                                          productController.allowCall.value = value;
                                          if (!productController.allowCall.value &&
                                              !productController.contactOnlyWithChat.value) {
                                            productController.contactOnlyWithChat.value = true;
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localLanguage.contact_only_in_chat,
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController.contactOnlyWithChat.value,
                                        onChanged: (value) {
                                          productController.contactOnlyWithChat.value = value;
                                          if (!productController.allowCall.value &&
                                              !productController.contactOnlyWithChat.value) {
                                            productController.allowCall.value = true;
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
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (productController.selectSubCategory.value?.filter != "real_estate_2")
          //Estate Type
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
            child: FormBuilderDropdown<String>(
              name: 'estateType',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              onChanged: (newValue) {
                productController.estateType.value = newValue!;
                productController.calculateFilledProductFields();
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
                return productController.estateTypeList
                    .map(
                      (estate) => DropdownMenuItem<String>(
                        alignment: Alignment.centerRight,
                        value: estate,
                        child: Text(
                          Get.find<LocalizationController>().getEstateTypeTranslated(estate),
                          style: regular.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              items: productController.estateTypeList
                  .map(
                    (estate) => DropdownMenuItem<String>(
                      value: estate,
                      child: Text(
                        Get.find<LocalizationController>().getEstateTypeTranslated(estate),
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

        //Address
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: FormBuilderTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
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

                ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localLanguage.address,
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
        if (productController.selectSubCategory.value?.filter != "real_estate_2")
          //Renovation Type
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
            child: FormBuilderDropdown<String>(
              name: 'estateDealType',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              onChanged: (newValue) {
                productController.estateDealType.value = newValue!;
                productController.calculateFilledProductFields();
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
                return productController.estateDealTypeList
                    .map(
                      (estate) => DropdownMenuItem<String>(
                        alignment: Alignment.centerRight,
                        value: estate,
                        child: Text(
                          Get.find<LocalizationController>().getEstateDealTypeTranslated(estate),
                          style: regular.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              items: productController.estateDealTypeList
                  .map(
                    (estate) => DropdownMenuItem<String>(
                      value: estate,
                      child: Text(
                        Get.find<LocalizationController>().getEstateDealTypeTranslated(estate),
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

        Row(
          children: [
            //Floor
            Expanded(
              child: Obx(
                () => _tile(
                  localLanguage.floor,
                  productController.selectFloor.value,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SingleDialogPicker(
                        title: localLanguage.select_number_of_floor,
                        items: List.generate(
                          15,
                          (index) => (index + 1).toString(),
                        ),
                        selectYear: productController.selectFloor,
                      ),
                    );
                  },
                ),
              ),
            ),
            //Room
            if (productController.selectSubCategory.value?.filter != "real_estate_2")
              Expanded(
                child: Obx(
                  () => _tile(
                    localLanguage.room,
                    productController.selectRoom.value,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SingleDialogPicker(
                          title: localLanguage.select_number_of_room,
                          items: List.generate(
                            10,
                            (index) => (index + 1).toString(),
                          ),
                          selectYear: productController.selectRoom,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        if (productController.selectSubCategory.value?.filter != "real_estate_2")
          //Lift
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h).copyWith(bottom: 0, right: 5.w),
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
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => _tile(
            localLanguage.brand,
            productController.selectedPhoneBrand.value,
            onTap: () {
              Get.bottomSheet(
                isScrollControlled: true,
                FilterBottomSheet(
                  title: localLanguage.brand,
                  data: homeController.mobileBrand,
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
    final localLanguage = AppLocalizations.of(Get.context!)!;
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
                        localLanguage.brand,
                        productController.selectedBrand.value?.brand ?? '',
                        onTap: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            CarBrandBottomSheet(
                              title: localLanguage.brand,
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
                          localLanguage.model,
                          productController.selectedModel.value?.name ?? '',
                          onTap: (productController.selectedBrand.value?.model ?? []).isEmpty
                              ? null
                              : () {
                                  Get.bottomSheet(
                                    CarModelBottomSheet(
                                      title: localLanguage.model,
                                      data: productController.selectedBrand.value!.model!,
                                      selectedData: productController.selectedModel,
                                    ),
                                  ).then((_) {
                                    productController.selectModelCarClass.value =
                                        productController.selectedModel.value?.modelClass ?? [];
                                    productController.calculateFilledProductFields();
                                  });
                                },
                        )),
                    Obx(() => _tile(
                          localLanguage.car_class,
                          productController.selectedModelClass.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: localLanguage.car_class,
                                data: productController.selectModelCarClass,
                                selectedData: productController.selectedModelClass,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          localLanguage.bodyType,
                          productController.selectedBodyType.value,
                          onTap: () {
                            RxList<String> translatedBodyTypeList = Get.find<LocalizationController>()
                                .getTranslatedBodyTypes(productController.dBodyType)
                                .obs;
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: localLanguage.body_type,
                                //data: productController.dBodyType,
                                data: translatedBodyTypeList,
                                selectedData: productController.selectedBodyType,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          localLanguage.drive_type,
                          productController.driveType.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: localLanguage.drive_type,
                                data: productController.dDriveType,
                                selectedData: productController.driveType,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          localLanguage.transmission,
                          productController.selectedTransmission.value,
                          onTap: () {
                            RxList<String> translatedTransmissionTypeList = Get.find<LocalizationController>()
                                .getTranslatedTransmissionTypes(filterController.dTransmission)
                                .obs;
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: localLanguage.transmission,
                                data: translatedTransmissionTypeList,
                                selectedData: productController.selectedTransmission,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          localLanguage.engine_type,
                          productController.selectedEngineType.value,
                          onTap: () {
                            Get.bottomSheet(
                              EngineTypeSheet(
                                title: localLanguage.engine_type,
                                data: filterController.dEngineType,
                                selectedData: productController.selectedEngineType,
                              ),
                            ).then((_) {
                              productController.calculateFilledProductFields();
                            });
                          },
                        )),
                    // Obx(() => _tile(
                    //       localLanguage.passedKm,
                    //       productController.selectedPassed.value,
                    //       onTap: () {
                    //         Get.bottomSheet(
                    //           EngineTypeSheet(
                    //             title: localLanguage.passedKm,
                    //             data: RxList.generate(200, (index) => (index * 100).toString()),
                    //             selectedData: productController.selectedPassed,
                    //           ),
                    //         ).then((_) {
                    //           productController.calculateFilledProductFields();
                    //         });
                    //       },
                    //     )),
                    Obx(
                      () => _tile(
                        localLanguage.year,
                        productController.selectedYear.value,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => SingleDialogPicker(
                              title: localLanguage.year,
                              selectYear: productController.selectedYear,
                            ),
                          );
                        },
                      ),
                    ),
                    //Selected Color
                    Obx(() => _tile(
                          localLanguage.color,
                          productController.selectedColor.firstOrNull ?? '',
                          onTap: () {
                            productController.selectedColor.clear();
                            Get.bottomSheet(
                              isScrollControlled: true,
                              ColorPickerSheet(
                                title: localLanguage.color,
                                data: filterController.dColor,
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
    bool isCar = productController.selectCategory.value?.filter?.toLowerCase() == 'car' ||
        (productController.selectSubCategory.value?.filter ?? "").toLowerCase() == "car";
    bool isRealEstate = (productController.selectCategory.value?.filter ?? '').toLowerCase().contains('real_estate') ||
        (productController.selectSubCategory.value?.filter ?? '').toLowerCase().contains('real_estate');
    bool isPhone = productController.selectCategory.value?.filter?.toLowerCase() == 'phone' ||
        productController.selectSubCategory.value?.filter?.toLowerCase() == 'phone';
    Map<String, dynamic> productPostMap = {};
    productPostMap['title'] = map['productName'];
    productPostMap['type'] = isCar
        ? 'car'
        : isRealEstate
            ? "real_estate"
            : isPhone
                ? 'phone'
                : 'general';
    productPostMap['category_id'] =
        productController.selectSubCategory.value?.sId ?? productController.selectCategory.value?.sId;
    productPostMap['description'] = map['description'];

    List<Map> media = [];
    for (var image in productController.pickImageList) {
      var mediaDataTemp = await imageToBase64(image.path);
      media.add(mediaDataTemp);
    }
    for (var video in productController.pickVideoList) {
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
      "free_to_call_from": "${productController.fromTime.value?.hour}:${productController.fromTime.value?.minute}",
      "free_to_call_to": '${productController.toTime.value?.hour}:${productController.toTime.value?.minute}',
      "allow_to_call": productController.allowCall.value,
      "contact_only_in_chat": productController.contactOnlyWithChat.value,
      "can_comment": true
    };
    productPostMap['price_info'] = {
      'price': num.parse(map['price']).toDouble(),
      "possible_exchange": productController.isExchange.value,
      "credit": productController.isCredit.value,
    };
    productPostMap['car_info'] = isCar
        ? {
            "condition": map['condition'],
            "brand": productController.selectedBrand.value?.brand,
            "model": productController.selectedModel.value?.name,
            "class": productController.selectedBodyType.value,
            "body_type": productController.selectedBodyType.value,
            "transmission": productController.selectedTransmission.value,
            "engine_type": productController.selectedEngineType.value,
            //"passed_km": num.parse(productController.selectedPassed.value).toInt(),
            "year": num.parse(productController.selectedYear.value).toInt(),
            "color": productController.selectedColor.first,
            "vin_code": map['vinCode'],
          }
        : null;
    productPostMap['estate_info'] = isRealEstate
        ? {
            "type": map['estateType'],
            "address": map['estateAddress'],
            "deal_type": map['estateDealType'],
            "floor": num.parse(productController.selectFloor.value).toInt(),
            "room": num.parse(productController.selectRoom.value).toInt(),
            "renov": productController.estateDealType.value,
            "lift": productController.isLeftAvalable.value,
          }
        : null;
    productPostMap['phone_info'] = isPhone ? {"brand": productController.selectedPhoneBrand.value} : null;

    await productController.postProduct(productPostMap);
  }

  _tile(String title, String value, {Function()? onTap}) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

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
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      value.isEmpty ? localLanguage.not_chosen_yet : value,
                      style: regular.copyWith(
                        fontSize: 14.sp,
                        fontWeight: value.isEmpty ? FontWeight.normal : FontWeight.w600,
                        color: value.isEmpty ? Colors.red : Colors.black87,
                      ),
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

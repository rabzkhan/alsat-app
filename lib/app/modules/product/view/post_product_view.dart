
import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../../components/custom_appbar.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../filter/widgets/filter_bottom_sheet.dart';
import '../controller/product_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widget/category_selection.dart';

class PostProductView extends StatefulWidget {
  const PostProductView({super.key});

  @override
  State<PostProductView> createState() => _PostProductViewState();
}

class _PostProductViewState extends State<PostProductView> {
  ProductController productController = Get.find();
  FilterController filterController = Get.find();
  final _formKey = GlobalKey<FormBuilderState>();

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
              RichText(
                text: TextSpan(
                    style: regular.copyWith(
                      fontSize: 10.sp,
                    ),
                    children: const [
                      TextSpan(text: 'By Posting, you confirm the agreement with terms and conditions of'),
                      TextSpan(
                        text: ' Alsat',
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ]),
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
                        'Cancel',
                        style: regular.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
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
                        onPressed: productController.isProductPosting.value
                            ? null
                            : () {
                                _formKey.currentState!.saveAndValidate();
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  productController.isProductPosting.value = true;
                                  addProductDataFormate(_formKey.currentState!.value).then((_) {
                                    _formKey.currentState!.reset();
                                  });
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
        body: SafeArea(
          child: Column(
            children: [
              //custom appbar
              const CustomAppBar(
                isShowFilter: false,
                isShowSearch: false,
                isShowNotification: false,
              ),
              Text(
                'Add Your Stuff',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              8.verticalSpace,
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
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), boxShadow: [
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
                            left: !productController.isShowPostProductVideo.value ? 0 : Get.width * .22,
                            child: Container(
                              width: Get.width * .22,
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
                                        'Image',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: !productController.isShowPostProductVideo.value ? Colors.white : null,
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
                                        'Video',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: productController.isShowPostProductVideo.value ? Colors.white : null,
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
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      children: [
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
                                                "Add",
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
                                    horizontal: 15.w,
                                    vertical: 25.h,
                                  ),
                                  height: 70.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        // Allows flexible width to avoid overflow
                                        child: SizedBox(
                                          height: 70.h,
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
                                                            borderRadius: BorderRadius.circular(10.r),
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
                                                          bottom: -2.h,
                                                          right: 0,
                                                          left: 0,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              productController.videoThumbnails.removeAt(index);
                                                              productController.pickVideoList.removeAt(index);
                                                            },
                                                            child: const Icon(
                                                              CupertinoIcons.xmark_circle_fill,
                                                              color: Colors.red,
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
                                          productController.pickVideo(context);
                                        },
                                        child: Container(
                                          width: 70.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            border: Border.all(
                                              width: 1,
                                              color: context.theme.disabledColor,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 30.sp,
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
                                  productController.selectCategory.value?.name ?? "Not choosen yet",
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const CategorySelection(),
                                    ).then((_) {
                                      productController.calculateFilledFields();
                                    });
                                  },
                                )),
                            Obx(() => productController.selectCategory.value?.name?.toLowerCase() == 'automobile'
                                ? _autoMobile(context)
                                : productController.selectCategory.value?.name?.toLowerCase() == 'real estate'
                                    ? _realEstate(context)
                                    : productController.selectCategory.value?.name?.toLowerCase() == 'phone'
                                        ? _phoneCategory(context)
                                        : const Center()),
                            //product Name
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                              child: FormBuilderTextField(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                name: 'productName',
                                onChanged: (newValue) {
                                  productController.calculateFilledFields();
                                },
                                controller: productController.productNameController,
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
                                    controller: productController.productDescriptionController,
                                    onChanged: (newValue) {
                                      productController.calculateFilledFields();
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
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  )
                                ],
                              ),
                            ),
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
                          leading: Padding(
                            padding: EdgeInsets.all(5.w).copyWith(right: 0),
                            child: CircularProgressIndicator(
                              value: .6,
                              strokeAlign: .1,
                              strokeWidth: 2,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          subtitle: Text(
                            '5/11 filled',
                            style: regular.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                          title: Text(
                            'Individual Info',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            CupertinoListTile(
                              onTap: () {
                                Get.bottomSheet(
                                  FilterBottomSheet(
                                    title: "Location",
                                    data: filterController.dlocation,
                                    selectedData: productController.selectedLocation,
                                  ),
                                );
                              },
                              title: Text(
                                "Location",
                                style: regular,
                              ),
                              trailing: Obx(() {
                                return productController.selectedLocation.value.isEmpty
                                    ? Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15.r,
                                      )
                                    : Text(
                                        productController.selectedLocation.value,
                                        style: regular.copyWith(
                                          fontSize: 12.sp,
                                          color: context.theme.primaryColor,
                                        ),
                                      );
                              }),
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
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                name: 'phoneNumber',
                                controller: productController.phoneNumberController,
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
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
                                            productController.showUserTimePickerDialog(context).then((value) {
                                              productController.fromTime.value = value;
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              'From ${productController.fromTime.value?.hour ?? '00'}:${productController.fromTime.value?.minute ?? '00'}',
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
                                            });
                                          },
                                          child: Obx(() {
                                            return Text(
                                              'To ${productController.toTime.value?.hour ?? '00'}:${productController.toTime.value?.minute ?? '00'}',
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
                                    'Allow me to call',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController.allowCall.value,
                                        onChanged: (value) {
                                          productController.allowCall.value = value;
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
                                    'Contact only in chat',
                                    style: regular,
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: Obx(() {
                                      return CupertinoSwitch(
                                        value: productController.contactOnlyWithChat.value,
                                        onChanged: (value) {
                                          productController.contactOnlyWithChat.value = value;
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
                          leading: Padding(
                            padding: EdgeInsets.all(5.w).copyWith(right: 0),
                            child: CircularProgressIndicator(
                              value: .6,
                              strokeAlign: .1,
                              strokeWidth: 2,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          subtitle: Text(
                            '5/11 filled',
                            style: regular.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                          title: Text(
                            'Price',
                            style: bold.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                              child: Row(
                                children: [
                                  Text('Price, \$', style: regular),
                                  5.horizontalSpace,
                                  Expanded(
                                    child: FormBuilderTextField(
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),
                                      name: 'price',
                                      controller: productController.priceController,
                                      decoration: InputDecoration(
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
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Possible Exchange',
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
                                    'Credit',
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
                            10.verticalSpace,
                          ],
                        )
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
              productController.calculateFilledFields();
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
              productController.calculateFilledFields();
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
              productController.calculateFilledFields();
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
                  name: 'floor',
                  onChanged: (newValue) {
                    productController.calculateFilledFields();
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
                  controller: productController.room,
                  name: 'room',
                  onChanged: (newValue) {
                    productController.calculateFilledFields();
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
        )
      ],
    );
  }

  Widget _phoneCategory(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          child: FormBuilderTextField(
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'brand',
            onChanged: (newValue) {
              productController.calculateFilledFields();
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
                    'Brand',
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
                        productController.selectedBrand.value,
                        onTap: () {
                          Get.bottomSheet(
                            FilterBottomSheet(
                              title: "Brand",
                              data: filterController.dbrand,
                              selectedData: productController.selectedBrand,
                            ),
                          ).then((_) {
                            productController.calculateFilledFields();
                          });
                        },
                      ),
                    ),
                    Obx(() => _tile(
                          "Model",
                          productController.selectedModel.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Model",
                                data: filterController.dmodel,
                                selectedData: productController.selectedModel,
                              ),
                            ).then((_) {
                              productController.calculateFilledFields();
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
                                data: filterController.dbodyType,
                                selectedData: productController.selectedBodyType,
                              ),
                            ).then((_) {
                              productController.calculateFilledFields();
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
                                selectedData: productController.selectedTransmission,
                              ),
                            ).then((_) {
                              productController.calculateFilledFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          "Engine Type",
                          productController.selectedEngineType.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Engine Type",
                                data: filterController.dengineType,
                                selectedData: productController.selectedEngineType,
                              ),
                            ).then((_) {
                              productController.calculateFilledFields();
                            });
                          },
                        )),
                    Obx(() => _tile(
                          "Passed, km",
                          productController.selectedPassed.value,
                        )),
                    Obx(() => _tile(
                          "Year",
                          productController.selectedYear.value,
                        )),
                    Obx(() => _tile(
                          "Color",
                          productController.selectedColor.value,
                          onTap: () {
                            Get.bottomSheet(
                              FilterBottomSheet(
                                title: "Color",
                                data: filterController.dcolor,
                                selectedData: productController.selectedColor,
                              ),
                            ).then((_) {
                              productController.calculateFilledFields();
                            });
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
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
                            controller: productController.vinCode,
                            name: 'vinCode',
                            onChanged: (newValue) {
                              productController.calculateFilledFields();
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Get.theme.primaryColor.withOpacity(.6),
                            ),
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
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ))
                        ],
                      ),
                    )
                  ],
                );
        }),
      ],
    );
  }

  Future<void> addProductDataFormate(Map<String, dynamic> map) async {
    Map<String, dynamic> productPostMap = {};
    productPostMap['title'] = map['productName'];
    productPostMap['type'] = productController.selectCategory.value?.name?.toLowerCase() == 'automobile'
        ? 'car'
        : productController.selectCategory.value?.name?.toLowerCase() == 'real estate'
            ? "real_estate"
            : productController.selectCategory.value?.name?.toLowerCase() == 'phone'
                ? 'phone'
                : 'general';
    productPostMap['category_id'] = productController.selectCategory.value?.sId;
    productPostMap['description'] = map['discription'];

    List<Map> media = [];
    for (var image in productController.pickImageList.value) {
      var mediaDataTemp = await imageToBase64(image.path);
      media.add(mediaDataTemp);
    }
    productPostMap['media'] = media;

    productPostMap['individual_info'] = {
      "location_province": productController.selectedLocation.value,
      "location_city": '',
      "location_geo": {
        "type": "Point",
        "coordinates": [10, -10],
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
    productPostMap['car_info'] = productController.selectCategory.value?.name?.toLowerCase() == 'automobile'
        ? {
            "condition": "used",
            "brand": productController.selectedBrand.value,
            "model": productController.selectedModel.value,
            "class": productController.selectedBodyType.value,
            "body_type": productController.selectedBodyType.value,
            "transmission": productController.selectedTransmission.value,
            "engine_type": productController.selectedEngineType.value,
            "passed_km": num.parse(productController.selectedPassed.value).toInt(),
            "year": num.parse(productController.selectedYear.value).toInt(),
            "color": productController.selectedColor.value,
            "vin_code": map['vinCode'],
          }
        : null;
    productPostMap['estate_info'] = productController.selectCategory.value?.name?.toLowerCase() == 'real estate'
        ? {
            "type": map['estateType'],
            "address": map['estateAddress'],
            "deal_type": map['estateDealType'],
            "floor": num.parse(map['floor']).toInt(),
            "floor_type": 2,
            "room": num.parse(map['room']).toInt(),
            "renov": "cosmetique",
            "lift": true
          }
        : null;
    productPostMap['phone_info'] =
        productController.selectCategory.value?.name?.toLowerCase() == 'phone' ? {"brand": map['brand']} : null;
    // log('productPostMap: $productPostMap');
    return await productController.postProduct(productPostMap);
  }

  _tile(String title, String value, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: regular.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Not chosen yet' : value,
                    style: regular.copyWith(
                      fontSize: 12.sp,
                      color: value.isEmpty ? Colors.red : context.theme.primaryColor,
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

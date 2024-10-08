import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../components/custom_appbar.dart';
import '../controller/product_controller.dart';

class PostProductView extends StatefulWidget {
  const PostProductView({super.key});

  @override
  State<PostProductView> createState() => _PostProductViewState();
}

class _PostProductViewState extends State<PostProductView> {
  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.secondaryHeaderColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "By Posting, you confirm the agreement with terms and conditions of Alsat",
              style: regular.copyWith(
                fontSize: 10.sp,
              ),
            ),
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
                        )),
                    child: Text(
                      'Cancel',
                      style: regular,
                    ),
                    onPressed: () {},
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.primaryColor,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Post",
                      style: regular.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
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
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
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
                          left: !productController.isShowPostProductVideo.value
                              ? 0
                              : Get.width * .22,
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
                                  productController
                                      .isShowPostProductVideo.value = false;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Obx(() {
                                    return Text(
                                      'Image',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: !productController
                                                .isShowPostProductVideo.value
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
                                      .isShowPostProductVideo.value = true;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Obx(() {
                                    return Text(
                                      'Video',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: productController
                                                .isShowPostProductVideo.value
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
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      /// Post Product Video
                      Obx(() {
                        return !productController.isShowPostProductVideo.value
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5.w,
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
                                                                      10.r),
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
                                                        bottom: -2.h,
                                                        right: 0,
                                                        left: 0,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            productController
                                                                .pickImageList
                                                                .removeAt(
                                                                    index);
                                                          },
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .xmark_circle_fill,
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
                                        productController.pickImage(context);
                                      },
                                      child: Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
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
                                                    alignment: Alignment.center,
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
                                                                      10.r),
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
                                                        bottom: -2.h,
                                                        right: 0,
                                                        left: 0,
                                                        child: GestureDetector(
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
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .xmark_circle_fill,
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
                                          borderRadius:
                                              BorderRadius.circular(10.r),
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
                          child: CircularProgressIndicator(
                            value: .8,
                            strokeAlign: .1,
                            strokeWidth: 2,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        subtitle: Text(
                          '9/11 filled',
                          style: regular.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
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
                          _tile("Category", "Automobile"),
                          _tile("Brand", "Hyundai"),
                          _tile("Model", "H9"),
                          _tile("Body Type", "H9"),
                          _tile("Transmission", "H9"),
                          _tile("Engine Type", "H9"),
                          _tile("Passed, km", "20000"),
                          _tile("Year", "1999"),
                          _tile("Color", "Orange"),
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
                                  name: '',
                                  initialValue: '1234567',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        Get.theme.primaryColor.withOpacity(.6),
                                  ),
                                  decoration: InputDecoration(
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
                              color: context.theme.shadowColor.withOpacity(.4),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 4.h),
                            child: TextField(
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
                                              .showUserTimePickerDialog(context)
                                              .then((value) {
                                            productController.fromTime.value =
                                                value;
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
                                          productController
                                              .showUserTimePickerDialog(context)
                                              .then((value) {
                                            productController.toTime.value =
                                                value;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Allow me to call',
                                  style: regular,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: true,
                                    onChanged: (value) {},
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
                                  'Contact only in chat',
                                  style: regular,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: true,
                                    onChanged: (value) {},
                                  ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 4.h),
                            child: Row(
                              children: [
                                Text('Price, \$', style: regular),
                                5.horizontalSpace,
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
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
                                  child: CupertinoSwitch(
                                    value: true,
                                    onChanged: (value) {},
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
                                  'Credit',
                                  style: regular,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: true,
                                    onChanged: (value) {},
                                  ),
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
    );
  }

  _tile(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoListTile(
          title: Text(
            title,
            style: bold,
          ),
          trailing: Text(
            value,
            style: regular.copyWith(
              fontSize: 12.sp,
              color: context.theme.primaryColor,
            ),
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
    );
  }
}

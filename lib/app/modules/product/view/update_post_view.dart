// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
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
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
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

import '../model/product_post_list_res.dart';
import '../video_edit/crop_video.dart';

import '../widget/post_category_selection.dart';
import '../widget/single_year_picker.dart';

class UpdatePostView extends StatefulWidget {
  final ProductModel productModel;

  const UpdatePostView({super.key, required this.productModel});

  @override
  State<UpdatePostView> createState() => _UpdatePostViewState();
}

class _UpdatePostViewState extends State<UpdatePostView> {
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: productController.postKey,
      child: Scaffold(
        backgroundColor: Get.theme.secondaryHeaderColor,
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Update Your Stuff',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              Text(
                'Post Images : ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                height: 80.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 100.h,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...(widget.productModel.media ?? []).map(
                                (e) => (e.contentType ?? '')
                                        .toLowerCase()
                                        .contains('image')
                                    ? Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15.r,
                                              ),
                                              child: NetworkImagePreview(
                                                fit: BoxFit.cover,
                                                width: 80.w,
                                                height: 70.h,
                                                url: "${e.name}",
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -10.h,
                                            right: 0,
                                            left: 0,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                xmarkIcon,
                                                height: 25.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(),
                              ),
                              ...List.generate(
                                productController.pickImageList.length,
                                (index) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                          child: Image.file(
                                            productController
                                                .pickImageList[index],
                                            fit: BoxFit.cover,
                                            width: 80.w,
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
                                            productController.pickImageList
                                                .removeAt(index);
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
                              color:
                                  context.theme.disabledColor.withOpacity(.4),
                            ),
                            Text(
                              "Add",
                              style: regular.copyWith(
                                color:
                                    context.theme.disabledColor.withOpacity(.4),
                                fontSize: 12.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Post Videos : ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                height: 80.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 100.h,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...(widget.productModel.media ?? []).map(
                                (e) => (e.contentType ?? '')
                                        .toLowerCase()
                                        .contains('image')
                                    ? Center()
                                    : Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15.r,
                                              ),
                                              child: FutureBuilder(
                                                  future: VideoThumbnail
                                                      .thumbnailData(
                                                    video: e.name ?? '',
                                                    imageFormat:
                                                        ImageFormat.JPEG,
                                                    maxHeight: 400,
                                                    quality: 100,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    return snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 80.w,
                                                            child:
                                                                CupertinoActivityIndicator(),
                                                          )
                                                        : Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Image.memory(
                                                                snapshot.data!,
                                                                width: 80.w,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .play_circle,
                                                                size: 20.sp,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ],
                                                          );
                                                  }),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -10.h,
                                            right: 0,
                                            left: 0,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                xmarkIcon,
                                                height: 25.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              ...List.generate(
                                productController.pickImageList.length,
                                (index) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                          child: Image.file(
                                            productController
                                                .pickImageList[index],
                                            fit: BoxFit.cover,
                                            width: 80.w,
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
                                            productController.pickImageList
                                                .removeAt(index);
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
                              color:
                                  context.theme.disabledColor.withOpacity(.4),
                            ),
                            Text(
                              "Add",
                              style: regular.copyWith(
                                color:
                                    context.theme.disabledColor.withOpacity(.4),
                                fontSize: 12.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

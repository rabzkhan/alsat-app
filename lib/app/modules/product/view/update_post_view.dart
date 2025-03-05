import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import '../controller/product_controller.dart';
import '../model/product_post_list_res.dart';

class UpdatePostView extends StatefulWidget {
  final ProductModel productModel;

  const UpdatePostView({super.key, required this.productModel});

  @override
  State<UpdatePostView> createState() => _UpdatePostViewState();
}

class _UpdatePostViewState extends State<UpdatePostView> {
  ProductController productController = Get.find();

  @override
  void initState() {
    Future.microtask(() {
      productController.pickUpdateImageList.value = [];
      productController.pickUpdateVideoList.value = [];
    });
    super.initState();
  }

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
              Row(
                children: [
                  Text(
                    'Post Images',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Obx(() {
                    return InkWell(
                      onTap: productController.isUploadingMediaImageInPost.value ||
                              productController.pickUpdateImageList.isEmpty
                          ? null
                          : () {
                              if (productController.pickUpdateImageList.isEmpty) {
                                CustomSnackBar.showCustomToast(
                                  message: 'Please select image',
                                );
                              } else {
                                productController.uploadMediaInPost(postId: widget.productModel.id ?? "");
                              }
                            },
                      child: productController.isUploadingMediaImageInPost.value
                          ? CupertinoActivityIndicator()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 10.w,
                              ),
                              decoration: BoxDecoration(
                                color: productController.isUploadingMediaImageInPost.value ||
                                        productController.pickUpdateImageList.isEmpty
                                    ? Get.theme.disabledColor
                                    : Get.theme.primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    'Upload Images',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    );
                  })
                ],
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
                                (e) => (e.contentType ?? '').toLowerCase().contains('image')
                                    ? Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
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
                                productController.pickUpdateImageList.length,
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
                                            productController.pickUpdateImageList[index],
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
                                            productController.pickUpdateImageList.removeAt(index);
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
                        productController.pickImage(context, external: true, pickItems: 4).then((onValue) {
                          productController.pickUpdateImageList.addAll(onValue ?? []);
                          productController.pickUpdateImageList.refresh();
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
                            color: context.theme.disabledColor.withValues(alpha: .4),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              size: 20.sp,
                              color: context.theme.disabledColor.withValues(alpha: .4),
                            ),
                            Text(
                              "Add",
                              style: regular.copyWith(
                                color: context.theme.disabledColor.withValues(alpha: .4),
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
              10.verticalSpace,
              Row(
                children: [
                  Text(
                    'Post Videos',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Obx(() {
                    return InkWell(
                      onTap: productController.isUploadingMediaVideoInPost.value ||
                              productController.pickUpdateVideoList.isEmpty
                          ? null
                          : () {
                              if (productController.pickUpdateVideoList.isEmpty) {
                                CustomSnackBar.showCustomToast(
                                  message: 'Please pick videos',
                                );
                              } else {
                                productController.uploadMediaInPost(
                                  isVideoUpload: true,
                                  postId: widget.productModel.id ?? "",
                                );
                              }
                            },
                      child: productController.isUploadingMediaVideoInPost.value
                          ? CupertinoActivityIndicator()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 10.w,
                              ),
                              decoration: BoxDecoration(
                                color: productController.isUploadingMediaVideoInPost.value ||
                                        productController.pickUpdateVideoList.isEmpty
                                    ? Get.theme.disabledColor
                                    : Get.theme.primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    'Upload Videos',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    );
                  })
                ],
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
                                (e) => (e.contentType ?? '').toLowerCase().contains('image')
                                    ? Center()
                                    : Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                15.r,
                                              ),
                                              child: FutureBuilder(
                                                  future: VideoThumbnail.thumbnailData(
                                                    video: e.name ?? '',
                                                    imageFormat: ImageFormat.JPEG,
                                                    maxHeight: 400,
                                                    quality: 100,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    return snapshot.connectionState == ConnectionState.waiting
                                                        ? Container(
                                                            alignment: Alignment.center,
                                                            width: 80.w,
                                                            child: CupertinoActivityIndicator(),
                                                          )
                                                        : Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Image.memory(
                                                                snapshot.data!,
                                                                width: 80.w,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              Icon(
                                                                Icons.play_circle,
                                                                size: 20.sp,
                                                                color: Colors.red,
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
                                productController.pickUpdateVideoList.length,
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
                                          child: FutureBuilder(
                                              future: VideoThumbnail.thumbnailData(
                                                video: productController.pickUpdateVideoList[index].path,
                                                imageFormat: ImageFormat.JPEG,
                                                maxHeight: 400,
                                                quality: 100,
                                              ),
                                              builder: (context, snapshot) {
                                                return snapshot.connectionState == ConnectionState.waiting
                                                    ? Container(
                                                        alignment: Alignment.center,
                                                        width: 80.w,
                                                        child: CupertinoActivityIndicator(),
                                                      )
                                                    : Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Image.memory(
                                                            snapshot.data!,
                                                            width: 80.w,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Icon(
                                                            Icons.play_circle,
                                                            size: 20.sp,
                                                            color: Colors.red,
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
                                          onTap: () {
                                            productController.pickUpdateVideoList.removeAt(index);
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
                        productController.pickVideo(context, external: true).then((value) {
                          if (value != null) {
                            productController.pickUpdateVideoList.add(value);
                            productController.pickUpdateVideoList.refresh();
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
                            color: context.theme.disabledColor.withValues(alpha: .4),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              size: 20.sp,
                              color: context.theme.disabledColor.withValues(alpha: .4),
                            ),
                            Text(
                              "Add",
                              style: regular.copyWith(
                                color: context.theme.disabledColor.withValues(alpha: .4),
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

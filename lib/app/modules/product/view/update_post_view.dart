import 'dart:io';
import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import '../controller/product_controller.dart';
import '../model/product_post_list_res.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdatePostView extends StatefulWidget {
  final ProductModel productModel;

  const UpdatePostView({super.key, required this.productModel});

  @override
  State<UpdatePostView> createState() => _UpdatePostViewState();
}

class _UpdatePostViewState extends State<UpdatePostView> {
  ProductController productController = Get.find();
  List<Media> photoOfPost = [];
  List<Media> videoOfPost = [];
  @override
  void initState() {
    Future.microtask(() {
      photoOfPost = (widget.productModel.media ?? [])
          .where((e) => (e.contentType ?? '').toLowerCase().contains('image'))
          .toList();
      videoOfPost = (widget.productModel.media ?? [])
          .where((e) => (e.contentType ?? '').toLowerCase().contains('video'))
          .toList();
      productController.pickUpdateImageList.value = [];
      productController.pickUpdateVideoList.value = [];
      setState(() {});
    });
    super.initState();
  }

  fetchUpdatedPostMedia() async {
    await productController.getSingleProductDetails(widget.productModel.id!, external: true);
    photoOfPost = (productController.selectExtraPostProductModel.value?.media ?? [])
        .where((e) => (e.contentType ?? '').toLowerCase().contains('image'))
        .toList();
    videoOfPost = (productController.selectExtraPostProductModel.value?.media ?? [])
        .where((e) => (e.contentType ?? '').toLowerCase().contains('video'))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return FormBuilder(
      key: productController.postUpdateFromKey,
      child: Scaffold(
        backgroundColor: Get.theme.secondaryHeaderColor,
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            localLanguage.update_your_stuff,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(),
            children: [
              Row(
                children: [
                  Text(
                    localLanguage.post_images,
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
                                  message: localLanguage.please_select_image,
                                );
                              } else {
                                productController.uploadMediaInPost(postId: widget.productModel.id ?? "").then((_) {
                                  fetchUpdatedPostMedia();
                                });
                              }
                            },
                      child: productController.isUploadingMediaImageInPost.value
                          ? CupertinoActivityIndicator()
                          : Container(
                              width: Get.width * .4,
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
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  ),
                                  5.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      maxLines: 1,
                                      localLanguage.upload_images,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
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
                height: 100.h,
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
                              ...photoOfPost.map(
                                (e) => Stack(
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
                                        onTap: () {
                                          if (photoOfPost.length > 1) {
                                            photoOfPost.remove(e);
                                            setState(() {});
                                            productController.deleteMediaInPost(
                                                pId: widget.productModel.id ?? '', mediaId: e.id ?? '');
                                          } else {
                                            CustomSnackBar.showCustomToast(
                                                message: localLanguage.you_can_not_delete_the_last_image);
                                          }
                                        },
                                        child: Image.asset(
                                          xmarkIcon,
                                          height: 25.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        productController.pickImage(context, external: true, pickItems: 4).then((onValue) {
                          List<File> files = onValue ?? [];
                          files.addAll(productController.pickUpdateImageList);
                          productController.pickUpdateImageList.clear();
                          productController.pickUpdateImageList.value = files;
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
                              localLanguage.add,
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
                    localLanguage.post_videos,
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
                                  message: localLanguage.please_pick_videos,
                                );
                              } else {
                                productController
                                    .uploadMediaInPost(
                                  isVideoUpload: true,
                                  postId: widget.productModel.id ?? "",
                                )
                                    .then((_) {
                                  fetchUpdatedPostMedia();
                                });
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
                                    localLanguage.upload_videos,
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
                              ...videoOfPost.map(
                                (e) => Stack(
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
                                        onTap: () {
                                          videoOfPost.remove(e);
                                          productController.deleteMediaInPost(
                                              pId: widget.productModel.id ?? '', mediaId: e.id ?? '');
                                        },
                                        child: Image.asset(
                                          xmarkIcon,
                                          height: 25.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                              )
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
                              localLanguage.add,
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

              /// Post Information Update
              10.verticalSpace,
              Text(
                localLanguage.post_title,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              6.verticalSpace,
              FormBuilderTextField(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                name: 'title',
                initialValue: widget.productModel.title,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
              10.verticalSpace,
              Text(
                localLanguage.description,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              6.verticalSpace,
              FormBuilderTextField(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                maxLines: 3,
                minLines: 3,
                name: 'description',
                initialValue: widget.productModel.description,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),

              10.verticalSpace,
              Text(
                localLanguage.price,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              6.verticalSpace,
              FormBuilderTextField(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
                keyboardType: TextInputType.number,
                name: 'price',
                initialValue: widget.productModel.priceInfo?.price?.toString(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
              30.verticalSpace,
              Obx(() {
                return CupertinoButton.tinted(
                  onPressed: productController.isUpdatingPost.value
                      ? null
                      : () {
                          productController.postUpdateFromKey.currentState?.save();
                          if (productController.postUpdateFromKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              "title": productController.postUpdateFromKey.currentState?.value['title'],
                              "description": productController.postUpdateFromKey.currentState?.value['description'],
                              "price_info": {
                                "price": double.parse(
                                    productController.postUpdateFromKey.currentState?.value['price'].toString() ?? '')
                              },
                            };
                            productController.updatePost(postId: widget.productModel.id ?? '', data: data);
                          }
                        },
                  child: productController.isUpdatingPost.value
                      ? CupertinoActivityIndicator()
                      : Text(localLanguage.update_info),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

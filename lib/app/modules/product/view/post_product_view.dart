import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), boxShadow: [
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
            )

            /// Post Product Video
            ,
            Obx(() {
              return !productController.isShowPostProductVideo.value
                  ? Container(
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
                                      productController.pickImageList.length,
                                      (index) {
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.r),
                                                child: Image.file(
                                                  productController.pickImageList[index],
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
                                                  productController.pickImageList.removeAt(index);
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
                              productController.pickImage(context);
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
            })
          ],
        ),
      ),
    );
  }
}

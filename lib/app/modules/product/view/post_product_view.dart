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
                          offset: Offset(0, 0),
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
            )
          ],
        ),
      ),
    );
  }
}

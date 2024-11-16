import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/network_image_preview.dart';
import '../model/product_post_list_res.dart';

class ProductCommentsView extends StatefulWidget {
  final ProductModel productModel;
  final ProductDetailsController productDetailsController;
  const ProductCommentsView(
      {super.key,
      required this.productDetailsController,
      required this.productModel});

  @override
  State<ProductCommentsView> createState() => _ProductCommentsViewState();
}

class _ProductCommentsViewState extends State<ProductCommentsView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    initMethod();
    super.initState();
  }

  initMethod() async {
    widget.productDetailsController
        .getProductComments(productId: widget.productModel.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(
              isShowBackButton: false,
              isShowFilter: false,
              isShowSearch: false,
            ),
            AppBar(
              toolbarHeight: 40,
              elevation: 0,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Comments',
                    style: regular.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discription',
                          style: regular.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          widget.productModel?.description ??
                              'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing ',
                          style: regular.copyWith(
                            fontSize: 14.sp,
                            color: context.theme.textTheme.bodyLarge?.color
                                ?.withOpacity(.6),
                          ),
                        ),
                        6.verticalSpace,
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Obx(() {
                    return Skeletonizer(
                      enabled: widget
                          .productDetailsController.isProductCommentList.value,
                      effect: ShimmerEffect(
                        baseColor: Get.theme.disabledColor.withOpacity(.2),
                        highlightColor: Colors.white,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      child: !widget.productDetailsController
                                  .isProductCommentList.value &&
                              widget.productDetailsController.productCommentList
                                  .isEmpty
                          ? SizedBox(
                              height: 300.h,
                              child: Center(
                                child: Text(
                                  'No Comment Avalable Right Now',
                                  style: regular.copyWith(
                                    fontSize: 14.sp,
                                    color: context
                                        .theme.textTheme.bodyLarge?.color
                                        ?.withOpacity(.4),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: widget.productDetailsController
                                      .isProductCommentList.value
                                  ? 10
                                  : widget.productDetailsController
                                      .productCommentList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var comment = widget.productDetailsController
                                        .isProductCommentList.value
                                    ? null
                                    : widget.productDetailsController
                                        .productCommentList[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: ListTile(
                                    tileColor:
                                        const Color(0xFFD9D9D9).withOpacity(.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    leading: NewworkImagePreview(
                                      radius: 40.r,
                                      url: comment?.user?.picture ?? '',
                                      height: 40.h,
                                      width: 40.w,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      comment?.user?.userName ?? 'User Name',
                                      style: regular.copyWith(),
                                    ),
                                    subtitle: Text(
                                      comment?.content ?? 'Comment',
                                      style: regular.copyWith(
                                        fontSize: 12.sp,
                                        color: context
                                            .theme.textTheme.bodyLarge?.color
                                            ?.withOpacity(.4),
                                      ),
                                    ),
                                    trailing: Text(
                                      timeAgo(
                                          comment?.createdAt ?? DateTime.now()),
                                      style: regular.copyWith(
                                        fontSize: 12.sp,
                                        color: context
                                            .theme.textTheme.bodyLarge?.color
                                            ?.withOpacity(.4),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  })
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9).withOpacity(.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                      width: 1,
                    )),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            controller: widget
                                .productDetailsController.commentController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter comment';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Write a comment',
                              hintStyle: regular.copyWith(
                                fontSize: 14.sp,
                                color: context.theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(.6),
                              ),
                              border: InputBorder.none,
                            ))),
                    MaterialButton(
                      color: context.theme.scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: const BorderSide(color: Color(0xFFD9D9D9))),
                      elevation: 0,
                      onPressed: widget.productDetailsController
                              .isProductCommentAdd.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                widget.productDetailsController
                                    .addProductComment(
                                  productId:
                                      (widget.productModel.id ?? 0).toString(),
                                  comment: widget.productDetailsController
                                      .commentController.text
                                      .trim(),
                                );
                              }
                            },
                      child: Obx(() {
                        return widget.productDetailsController
                                .isProductCommentAdd.value
                            ? const CupertinoActivityIndicator()
                            : Text(
                                'Send',
                                style: regular,
                              );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

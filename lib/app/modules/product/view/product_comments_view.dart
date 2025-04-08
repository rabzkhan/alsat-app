import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/product_list_tile.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  TextEditingController commentController = TextEditingController();
  AuthController authController = Get.find();
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
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${widget.productModel.title}',
          style: regular.copyWith(
            fontSize: 16.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IgnorePointer(
              ignoring: true,
              child: ProductListTile(
                productModel: widget.productModel,
                showBorder: false,
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ).copyWith(top: 0),
                children: [
                  Obx(() {
                    return Skeletonizer(
                      enabled: widget
                          .productDetailsController.isProductCommentList.value,
                      // effect: ShimmerEffect(
                      //   baseColor: Get.theme.disabledColor.withOpacity(.2),
                      //   highlightColor: Colors.white,
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      child: !widget.productDetailsController
                                  .isProductCommentList.value &&
                              widget.productDetailsController.productCommentList
                                  .isEmpty
                          ? SizedBox(
                              height: 300.h,
                              child: Center(
                                child: Text(
                                  localLanguage.no_comment_available_right_now,
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: AppColors.primary,
                                        child: NetworkImagePreview(
                                          radius: 40.r,
                                          url: comment?.user?.picture ?? '',
                                          height: 40.h,
                                          width: 40.w,
                                          fit: BoxFit.cover,
                                          error: Image.asset(userDefaultIcon),
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Get.theme.disabledColor
                                                    .withOpacity(.08),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment?.user?.userName ??
                                                        'User Name',
                                                    style: bold.copyWith(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  5.verticalSpace,
                                                  Text(
                                                    comment?.content ??
                                                        'Comment',
                                                    style: regular.copyWith(
                                                      fontSize: 14.sp,
                                                      color: context
                                                          .theme
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color
                                                          ?.withOpacity(.7),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            5.verticalSpace,
                                            Text(
                                              timeAgo(comment?.createdAt ??
                                                  DateTime.now()),
                                              style: regular.copyWith(
                                                fontSize: 12.sp,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    );
                  })
                ],
              ),
            ),
            if ((widget.productModel.individualInfo?.canComment ?? true) &&
                authController.userDataModel.value.id != null)
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(.2),
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                        width: 1,
                      )),
                  child: Row(
                    children: [
                      5.horizontalSpace,
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: TextFormField(
                            maxLines: 1,
                            controller: commentController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localLanguage.please_enter_comment;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: localLanguage.write_a_comment,
                              hintStyle: regular.copyWith(
                                fontSize: 14.sp,
                                color: context.theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(.6),
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: widget.productDetailsController
                                        .isProductCommentAdd.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          widget.productDetailsController
                                              .addProductComment(
                                            productId:
                                                (widget.productModel.id ?? 0)
                                                    .toString(),
                                            comment:
                                                commentController.text.trim(),
                                          )
                                              .then((onValue) {
                                            commentController.clear();
                                          });
                                        }
                                      },
                                icon: Icon(
                                  Icons.send,
                                  size: 30.r,
                                ),
                              ),
                            ),
                          ),
                        ),
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

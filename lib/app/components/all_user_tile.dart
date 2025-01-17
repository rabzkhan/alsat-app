import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/theme/app_text_theme.dart';
import '../common/const/image_path.dart';
import '../modules/authentication/model/user_data_model.dart';
import '../modules/product/controller/product_details_controller.dart';
import '../modules/product/view/client_profile_view.dart';
import 'network_image_preview.dart';

class AllUserTile extends StatelessWidget {
  final UserDataModel premiumUserModel;
  const AllUserTile({super.key, required this.premiumUserModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('premiumUserModel.id: ${premiumUserModel.id}');
        ProductDetailsController productDetailsController =
            Get.put(ProductDetailsController(), tag: premiumUserModel.id);
        productDetailsController.postUserModel.value = premiumUserModel;
        productDetailsController.isFetchUserLoading.value = false;
        Get.to(
          () => ClientProfileView(
            userId: (productDetailsController.postUserModel.value?.id ?? '')
                .toString(),
            productDetailsController: productDetailsController,
          ),
          transition: Transition.fadeIn,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        height: 100.h,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.disabledColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: NetworkImagePreview(
                radius: 10.r,
                width: 90.w,
                height: 100.h,
                fit: BoxFit.cover,
                url: premiumUserModel.picture ?? '',
                error: Image.asset(userDefaultIcon),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 18.r,
                        color: (premiumUserModel.premium ?? false)
                            ? Get.theme.primaryColor
                            : Get.theme.disabledColor.withOpacity(.1),
                      ),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          premiumUserModel.userName ?? 'Premium User Name',
                          style: bold.copyWith(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  3.verticalSpace,
                  Text(
                      (premiumUserModel.email ?? '').isNotEmpty
                          ? premiumUserModel.email ?? ''
                          : premiumUserModel.phone ?? 'No Email',
                      style: regular.copyWith(
                        fontSize: 12.sp,
                      )),
                  if ((premiumUserModel.location?.province ?? '').isNotEmpty ||
                      (premiumUserModel.location?.city ?? '').isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Text(
                        '${premiumUserModel.location?.province ?? ''} ${premiumUserModel.location?.city ?? '--'} , ${premiumUserModel.categories?.firstOrNull ?? ''}',
                        style: regular.copyWith(
                          fontSize: 12.sp,
                          color: context.theme.disabledColor,
                        ),
                      ),
                    ),
                  3.verticalSpace,
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 15.r,
                            color: (premiumUserModel.protectionLabel ?? false)
                                ? Get.theme.primaryColor
                                : Get.theme.disabledColor.withOpacity(.1),
                          ),
                          3.horizontalSpace,
                          Text(
                            'Buyer Protection',
                            style: regular.copyWith(
                              color: Get.theme.disabledColor,
                              fontSize: 10.sp,
                            ),
                          )
                        ],
                      ),
                      5.horizontalSpace,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 15.r,
                            color: (premiumUserModel.flag ?? false)
                                ? Get.theme.primaryColor
                                : Get.theme.disabledColor.withOpacity(.1),
                          ),
                          3.horizontalSpace,
                          Text(
                            'Credit',
                            style: regular.copyWith(
                              color: Get.theme.disabledColor,
                              fontSize: 10.sp,
                            ),
                          )
                        ],
                      ),
                      20.horizontalSpace,
                      Text(
                        'Follower: ${premiumUserModel.followers ?? 0}',
                        style: regular.copyWith(
                          color: Get.theme.primaryColor,
                          fontSize: 12.sp,
                        ),
                      )
                    ],
                  ),
                  3.verticalSpace,
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 15.r),
          ],
        ),
      ),
    );
  }
}

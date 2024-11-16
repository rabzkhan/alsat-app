import 'package:alsat/app/modules/auth_user/controller/user_controller.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../product/view/client_profile_view.dart';

class MyFollowers extends StatefulWidget {
  const MyFollowers({super.key});

  @override
  State<MyFollowers> createState() => _MyFollowersState();
}

class _MyFollowersState extends State<MyFollowers> {
  UserController userController = Get.find();
  @override
  void initState() {
    if (userController.followerRes.value == null) {
      userController.getUserFollower();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Skeletonizer(
        enabled: userController.isFollowerLoading.value,
        effect: ShimmerEffect(
          baseColor: Get.theme.disabledColor.withOpacity(.2),
          highlightColor: Colors.white,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          itemCount: userController.isFollowerLoading.value
              ? 10
              : (userController.followerRes.value?.data ?? []).length,
          itemBuilder: (context, index) {
            var user = userController.followerRes.value?.data?[index];
            return ListTile(
              onTap: () {
                ProductDetailsController productDetailsController = Get.put(
                    ProductDetailsController(),
                    tag: user?.follower?.id.toString());
                productDetailsController.selectUserId =
                    user?.follower?.id ?? '';
                productDetailsController.getUserMyUserId(
                    userId: user?.follower?.id ?? '');
                Get.to(
                  () => ClientProfileView(
                    userId: user?.follower?.id ?? '',
                    productDetailsController: productDetailsController,
                  ),
                  transition: Transition.fadeIn,
                );
              },
              tileColor: const Color(0xFFD9D9D9),
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 22.r,
                child: NewworkImagePreview(
                  radius: 22.r,
                  url: user?.follower?.picture ?? '',
                  height: 44.h,
                  width: 44.w,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                user?.follower?.userName ?? 'John Coltrane',
                style: bold.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              subtitle: Text(
                DateFormat('MMMM dd yyyy')
                    .format(user?.followedAt ?? DateTime.now()),
                style: regular.copyWith(
                  fontSize: 10.sp,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

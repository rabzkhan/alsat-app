import 'package:alsat/app/modules/auth_user/controller/user_controller.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../product/view/client_profile_view.dart';

class MyFollowing extends StatefulWidget {
  const MyFollowing({super.key});

  @override
  State<MyFollowing> createState() => _MyFollowingState();
}

class _MyFollowingState extends State<MyFollowing> {
  UserController userController = Get.find();
  @override
  void initState() {
    if (userController.followingList.isEmpty) {
      userController.getUserFollowing();
    }
    super.initState();
  }

  RefreshController followingRefreshController =
      RefreshController(initialRefresh: false);
  void followingRefresh() async {
    await userController.getUserFollowing();
    followingRefreshController.refreshCompleted();
  }

  void followingLoading() async {
    await userController.getUserFollowing(
        next: userController.followingList.last.followedAt);
    followingRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          waterDropColor: context.theme.primaryColor,
        ),
        controller: followingRefreshController,
        onRefresh: followingRefresh,
        onLoading: followingLoading,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          itemCount: userController.isFollowingLoading.value
              ? 10
              : (userController.followingList).length,
          itemBuilder: (context, index) {
            var user = userController.isFollowingLoading.value
                ? null
                : userController.followingList[index];
            return Skeletonizer(
              enabled: userController.isFollowingLoading.value,
              effect: ShimmerEffect(
                baseColor: Get.theme.disabledColor.withOpacity(.2),
                highlightColor: Colors.white,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              child: ListTile(
                onTap: () {
                  ProductDetailsController productDetailsController = Get.put(
                      ProductDetailsController(),
                      tag: user?.follower?.id.toString());
                  productDetailsController.selectUserId =
                      user?.follower?.id ?? '';
                  productDetailsController.getUserByUId(
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
                  DateFormat('MMMM dd yyyy').format(
                      DateTime.tryParse(user?.followedAt ?? '') ??
                          DateTime.now()),
                  style: regular.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/all_user_tile.dart';
import 'package:alsat/app/components/image_preview.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../../components/network_image_preview.dart';
import '../../app_home/controller/home_controller.dart';

class HomeStorySection extends StatelessWidget {
  const HomeStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    AuthController authController = Get.find();
    return Obx(() {
      return Stories(
        autoPlayDuration: const Duration(seconds: 5),
        highLightColor: AppColors.primary,
        paddingColor: AppColors.secondary,
        fullpageVisitedColor: AppColors.primary,
        fullpageUnisitedColor: Colors.grey,
        storyStatusBarColor: Colors.white,
        circlePadding: 2,
        addOption: Obx(() {
          return InkWell(
            onTap: homeController.isStoryPostLoading.value
                ? null
                : () {
                    homeController.storyPickImage(context).then((_) {
                      if (homeController.pickStoryImageList.firstOrNull !=
                          null) {
                        homeController.openEditor(context);
                      }
                    });
                  },
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 3.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      radius: 27,
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            NetworkImagePreview(
                              radius: 50.r,
                              height: 50,
                              width: 50,
                              url:
                                  '${authController.userDataModel.value.picture}',
                              error: Image.asset(userDefaultIcon),
                            ),
                            CircleAvatar(
                              radius: 27,
                              backgroundColor:
                                  AppColors.primary.withOpacity(.3),
                              child: homeController.isStoryPostLoading.value
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 23.r,
                                      color: AppColors.scaffoldBackgroundColor,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Add Story',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          );
        }),
        storyItemList: [
          ...homeController.storyList.map(
            (e) => StoryItem(
              name: "${e.user?.userName}",
              thumbnail: NetworkImage(
                e.user?.picture ?? '',
              ),
              stories: [
                ...(e.stories ?? []).map(
                  (e) => Scaffold(
                    body: Center(
                      child: NetworkImagePreview(
                        url: e.media?.name ?? '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

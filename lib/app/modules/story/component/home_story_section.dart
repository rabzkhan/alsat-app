// ignore_for_file: deprecated_member_use
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/app/modules/story/component/story_video_player.dart';
import 'package:alsat/app/modules/story/screen/story_video_editor.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';
import '../../app_home/controller/home_controller.dart';
import '../../product/view/client_profile_view.dart';

class HomeStorySection extends StatelessWidget {
  const HomeStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    final HomeController homeController = Get.find();
    AuthController authController = Get.find();

    return Obx(() {
      return authController.userDataModel.value.id == null
          ? Center()
          : Stories(
              autoPlayDuration: const Duration(seconds: 10),
              highLightColor: AppColors.primary,
              paddingColor: AppColors.secondary,
              fullpageVisitedColor: AppColors.primary,
              fullpageUnisitedColor: Colors.grey,
              storyStatusBarColor: Colors.white,
              circlePadding: 2,
              //
              onPageChanged: (String userId) {
                Get.put(ProductDetailsController());
                Get.to(
                  () => ClientProfileView(
                    userId: userId,
                    productDetailsController: Get.find<ProductDetailsController>(),
                  ),
                  transition: Transition.fadeIn,
                );
              },
              addOption: Obx(() {
                return (authController.userDataModel.value.premium ?? false)
                    ? InkWell(
                        onTap: homeController.isStoryPostLoading.value
                            ? null
                            : () {
                                homeController.storyAssetPicker(context).then((_) {
                                  if (homeController.pickStoryImageList.isNotEmpty) {
                                    homeController.openEditor(Get.context!);
                                  } else if (homeController.pickStoryVideoList.isNotEmpty) {
                                    Get.to(
                                      () => StoryVideoEditor(
                                        homeController.pickStoryVideoList.first,
                                      ),
                                    );
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
                                //backgroundColor: AppColors.primary,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.secondary,
                                  radius: 27,
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 27,
                                          backgroundColor: AppColors.primary.withOpacity(.5),
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
                              5.verticalSpace,
                              Text(
                                localLanguage.add_story,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              5.verticalSpace,
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 10.w,
                      );
              }),
              storyItemList: [
                ...homeController.storyList.map(
                  (e) => StoryItem(
                    userId: "${e.user?.id}",
                    name: "${e.user?.userName}",
                    thumbnail: NetworkImage(
                      e.user?.picture ?? '',
                    ),
                    stories: [
                      ...(e.stories ?? []).map(
                        (e) => StoryMainModel(
                          isVideo: (e.media?.type == "video" && e.media?.name != null && e.media!.name!.isNotEmpty),
                          url: e.media?.name ?? '',
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

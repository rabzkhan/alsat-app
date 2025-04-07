import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/custom_footer_widget.dart';
import 'package:alsat/app/components/custom_header_widget.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/story/model/story_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_home/controller/home_controller.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Obx(() {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: CustomHeaderWidget(),
        footer: CustomFooterWidget(),
        controller: homeController.archiveStoryRefreshController,
        onRefresh: homeController.archiveStoryRefresh,
        onLoading: homeController.archiveStoryLoading,
        child: homeController.authUserStory.isEmpty &&
                homeController.authUserArchiveStory.isEmpty &&
                !homeController.isStoryLoading.value
            ? NoDataWidget()
            : ListView(
                children: [
                  Obx(() {
                    return ((homeController
                                    .authUserStory.firstOrNull?.stories ??
                                [])
                            .isEmpty)
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 18.sp),
                                Text(
                                  'Live Stories',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
                  10.verticalSpace,
                  Obx(() {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: .6,
                      ),
                      itemCount:
                          (homeController.authUserStory.firstOrNull?.stories ??
                                  [])
                              .length,
                      itemBuilder: (context, index) {
                        var e = homeController
                            .authUserStory.firstOrNull?.stories
                            ?.elementAtOrNull(index);
                        return _storyItem(e);
                      },
                    );
                  }),
                  10.verticalSpace,
                  Obx(() {
                    return ((homeController.authUserArchiveStory).isEmpty)
                        ? Center()
                        : Row(
                            children: [
                              Icon(Icons.play_arrow_rounded, size: 18.sp),
                              Text(
                                'Archive Stories',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          );
                  }),
                  10.verticalSpace,
                  Obx(() {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: .6,
                      ),
                      itemCount: (homeController.authUserArchiveStory).length,
                      itemBuilder: (context, index) {
                        var e = homeController.authUserArchiveStory
                            .elementAtOrNull(index);
                        return _storyItem(e, isArchive: true);
                      },
                    );
                  }),
                ],
              ),
      );
    });
  }

  Widget _storyItem(Story? e, {bool isArchive = false}) {
    HomeController homeController = Get.find();
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoActionSheet(
            actions: [
              _items(e, height: 200.h),
              if (isArchive)
                Obx(() {
                  return CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: homeController.isStoryReporting.value
                        ? () {/*...*/}
                        : () {
                            homeController.rePostStory(e?.id ?? "");
                          },
                    child: homeController.isStoryReporting.value
                        ? CupertinoActivityIndicator()
                        : const Text('Re-Post'),
                  );
                }),
              if (!isArchive)
                Obx(() {
                  return CupertinoActionSheetAction(
                    onPressed: homeController.isStoryDeleting.value
                        ? () {}
                        : () {
                            homeController.deleteStory(e!);
                          },
                    child: homeController.isStoryDeleting.value
                        ? CupertinoActivityIndicator()
                        : const Text('Delete'),
                  );
                }),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'),
            ),
          ),
        );
      },
      child: _items(e),
    );
  }

  Container _items(Story? e, {double? height}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: (e?.media?.type == "video" &&
              e?.media?.name != null &&
              (e?.media?.name ?? '').isNotEmpty)
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(height == null ? 10.r : 0),
                  child: FutureBuilder(
                      future: VideoThumbnail.thumbnailData(
                        video: e?.media?.name ?? '',
                        imageFormat: ImageFormat.JPEG,
                      ),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container(
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: height,
                                  ),
                                  Icon(
                                    Icons.play_circle,
                                    size: 30.sp,
                                    color: Colors.red,
                                  ),
                                ],
                              );
                      }),
                ),
              ],
            )
          : NetworkImagePreview(
              radius: height == null ? 10.r : 0,
              url: e?.media?.name ?? '',
              height: height,
            ),
    );
  }
}

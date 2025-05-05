import 'dart:isolate';

import 'package:alsat/app/components/custom_footer_widget.dart';
import 'package:alsat/app/components/custom_header_widget.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/story/model/story_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_home/controller/home_controller.dart';
import '../controller/thumbnail.dart';
import 'widgets/story_isolate.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
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
                    return ((homeController.authUserStory.firstOrNull?.stories ?? []).isEmpty)
                        ? Center()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 18.sp),
                                Text(
                                  localLanguage.live_stories,
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
                      itemCount: (homeController.authUserStory.firstOrNull?.stories ?? []).length,
                      itemBuilder: (context, index) {
                        var e = homeController.authUserStory.firstOrNull?.stories?.elementAtOrNull(index);
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
                                localLanguage.archive_stories,
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
                        var e = homeController.authUserArchiveStory.elementAtOrNull(index);
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
    final localLanguage = AppLocalizations.of(Get.context!)!;
    HomeController homeController = Get.find();
    ThumbnailService thumbnailService = Get.put(ThumbnailService());
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
                        : Text(localLanguage.re_post),
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
                        : Text(localLanguage.delete),
                  );
                }),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
              },
              child: Text(localLanguage.cancel),
            ),
          ),
        );
      },
      child: _items(e),
    );
  }

  Widget _items(Story? e, {double? height}) {
    final thumbnailService = Get.find<ThumbnailService>();

    if (e?.media?.type == "video" && (e?.media?.name ?? '').isNotEmpty) {
      thumbnailService.loadThumbnail(e!.media!.name!); // Load if not loaded

      return Obx(() {
        final thumbnail = thumbnailService.thumbnails[e.media!.name!];

        if (thumbnail == null) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(height == null ? 10.r : 0),
                child: Image.memory(thumbnail, fit: BoxFit.cover),
              ),
              Center(
                child: Icon(
                  Icons.video_file_rounded,
                  color: Colors.white,
                ),
              )
            ],
          );
        }
      });
    } else {
      return NetworkImagePreview(
        radius: height == null ? 10.r : 0,
        url: e?.media?.name ?? '',
        height: height,
      );
    }
  }

  Future<Uint8List?> generateThumbnailInFlutterIsolate(String videoPath) async {
    final ReceivePort receivePort = ReceivePort();

    await FlutterIsolate.spawn(
      isolateEntry,
      {
        'videoPath': videoPath,
        'sendPort': receivePort.sendPort,
      },
    );

    final Uint8List? thumbnail = await receivePort.first as Uint8List?;
    return thumbnail;
  }
}

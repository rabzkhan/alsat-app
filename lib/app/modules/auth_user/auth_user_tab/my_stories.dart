import 'package:alsat/app/components/custom_footer_widget.dart';
import 'package:alsat/app/components/custom_header_widget.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/story/model/story_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app_home/controller/home_controller.dart';
import '../controller/thumbnail.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    final homeController = Get.find<HomeController>();
    ThumbnailService thumbnailService = Get.put(ThumbnailService());

    return Obx(() {
      final hasNoData = homeController.authUserStory.isEmpty &&
          homeController.authUserArchiveStory.isEmpty &&
          !homeController.isStoryLoading.value;

      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: CustomHeaderWidget(),
        footer: CustomFooterWidget(),
        controller: homeController.archiveStoryRefreshController,
        onRefresh: homeController.archiveStoryRefresh,
        onLoading: homeController.archiveStoryLoading,
        child: hasNoData
            ? const NoDataWidget()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                children: [
                  if ((homeController.authUserStory.firstOrNull?.stories ?? []).isNotEmpty)
                    _sectionHeader(localLanguage.live_stories),
                  10.verticalSpace,
                  _buildStoryGrid(
                    homeController.authUserStory.firstOrNull?.stories ?? [],
                    isArchive: false,
                    thumbnailService: thumbnailService,
                  ),
                  10.verticalSpace,
                  if (homeController.authUserArchiveStory.isNotEmpty) _sectionHeader(localLanguage.archive_stories),
                  10.verticalSpace,
                  _buildStoryGrid(
                    homeController.authUserArchiveStory,
                    isArchive: true,
                    thumbnailService: thumbnailService,
                  ),
                ],
              ),
      );
    });
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Icon(Icons.play_arrow_rounded, size: 18.sp),
        SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildStoryGrid(
    List<Story> stories, {
    required bool isArchive,
    required ThumbnailService thumbnailService,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: .6,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _storyItem(story, isArchive: isArchive, thumbnailService: thumbnailService);
      },
    );
  }

  Widget _storyItem(
    Story story, {
    required bool isArchive,
    required ThumbnailService thumbnailService,
  }) {
    final homeController = Get.find<HomeController>();
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoActionSheet(
            actions: [
              _buildThumbnailView(story, thumbnailService, height: 200.h),
              if (isArchive)
                Obx(() => CupertinoActionSheetAction(
                      onPressed: homeController.isStoryReporting.value
                          ? () {}
                          : () => homeController.rePostStory(story.id ?? ""),
                      child: homeController.isStoryReporting.value
                          ? const CupertinoActivityIndicator()
                          : Text(localLanguage.re_post),
                    )),
              if (!isArchive)
                Obx(() => CupertinoActionSheetAction(
                      onPressed: homeController.isStoryDeleting.value ? () {} : () => homeController.deleteStory(story),
                      child: homeController.isStoryDeleting.value
                          ? const CupertinoActivityIndicator()
                          : Text(localLanguage.delete),
                    )),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Get.back(),
              child: Text(localLanguage.cancel),
            ),
          ),
        );
      },
      child: _buildThumbnailView(story, thumbnailService),
    );
  }

  Widget _buildThumbnailView(
    Story story,
    ThumbnailService thumbnailService, {
    double? height,
  }) {
    final isVideo = story.media?.type == "video";
    final mediaUrl = story.media?.name ?? '';

    if (isVideo && mediaUrl.isNotEmpty) {
      thumbnailService.loadThumbnail(mediaUrl);
      return Obx(() {
        final thumbnail = thumbnailService.thumbnails[mediaUrl];
        if (thumbnail == null) {
          return const Center(child: CupertinoActivityIndicator());
        }
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(height == null ? 10.r : 0),
              child: Image.memory(thumbnail, fit: BoxFit.cover),
            ),
            const Center(child: Icon(Icons.video_file_rounded, color: Colors.white)),
          ],
        );
      });
    } else {
      return NetworkImagePreview(
        radius: height == null ? 10.r : 0,
        url: mediaUrl,
        height: height,
      );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alsat/app/modules/story/model/story_res.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alsat/app/components/custom_footer_widget.dart';
import 'package:alsat/app/components/custom_header_widget.dart';
import 'package:alsat/app/components/no_data_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:alsat/l10n/app_localizations.dart';
import '../../app_home/controller/home_controller.dart';
import '../controller/thumbnail.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(context)!;
    final HomeController homeController = Get.find();
    final thumbnailService = Get.put(ThumbnailService());

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
            ? const NoDataWidget()
            : ListView(
                children: [
                  if ((homeController.authUserStory.firstOrNull?.stories ?? [])
                      .isNotEmpty)
                    _sectionTitle(localLanguage.live_stories),
                  _storyGrid(
                      homeController.authUserStory.firstOrNull?.stories ?? [],
                      false),
                  if ((homeController.authUserArchiveStory).isNotEmpty)
                    _sectionTitle(localLanguage.archive_stories),
                  _storyGrid(homeController.authUserArchiveStory, true),
                ],
              ),
      );
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(Icons.play_arrow_rounded, size: 18.sp),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _storyGrid(List<Story> stories, bool isArchive) {
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
        var story = stories.elementAt(index);
        return _storyItem(story, isArchive: isArchive);
      },
    );
  }

  Widget _storyItem(Story story, {bool isArchive = false}) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    final HomeController homeController = Get.find();
    final thumbnailService = Get.put(ThumbnailService());

    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoActionSheet(
            actions: [
              //_items(story, height: 200.h),
              if (isArchive)
                _repostAction(homeController, story, localLanguage),
              if (!isArchive)
                _deleteAction(homeController, story, localLanguage),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Get.back(),
              child: Text(localLanguage.cancel),
            ),
          ),
        );
      },
      child: _thumbnailWidget(story),
    );
  }

// When building thumbnail
  Widget _thumbnailWidget(Story story, {double? height}) {
    final thumbnailService = Get.find<ThumbnailService>();

    if (story.media?.type == "video" && (story.media?.name ?? '').isNotEmpty) {
      final videoPath = story.media!.name!;
      thumbnailService.loadThumbnail(videoPath);

      return Obx(() {
        final thumbnail = thumbnailService.thumbnails[videoPath];
        if (thumbnail == null && thumbnailService.loading[videoPath] == true) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (thumbnail != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(height == null ? 10.r : 0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.memory(
                    thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Center(
                  child: Icon(Icons.video_file_rounded, color: Colors.white)),
            ],
          );
        } else {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        }
      });
    } else {
      return NetworkImagePreview(
        radius: height == null ? 10.r : 0,
        url: story.media?.name ?? '',
        height: height,
      );
    }
  }

  Widget _repostAction(
      HomeController controller, Story story, AppLocalizations localLanguage) {
    return Obx(() {
      final isLoading = controller.isStoryReporting.value;
      return CupertinoActionSheetAction(
        // Ensure we always provide a valid callback, using an empty function when disabled
        onPressed: isLoading
            ? () {} // Empty function to prevent null callback
            : () => controller.rePostStory(story.id ?? ""),
        child: isLoading
            ? const CupertinoActivityIndicator() // Shows the activity indicator while loading
            : Text(localLanguage.re_post),
      );
    });
  }

  Widget _deleteAction(
      HomeController controller, Story story, AppLocalizations localLanguage) {
    return Obx(() {
      final isDeleting = controller.isStoryDeleting.value;
      return CupertinoActionSheetAction(
        // Ensure that we provide a valid callback, using an empty function when disabled
        onPressed: isDeleting
            ? () {} // Empty function to prevent null callback
            : () => controller.deleteStory(story),
        child: isDeleting
            ? const CupertinoActivityIndicator() // Show activity indicator while deleting
            : Text(localLanguage.delete),
      );
    });
  }
}

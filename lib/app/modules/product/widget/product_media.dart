import 'dart:developer';

import 'package:alsat/app/components/multi_image_preview.dart';
import 'package:alsat/app/modules/product/model/product_post_list_res.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:pod_player/pod_player.dart';

import '../../../components/network_image_preview.dart';

class ProductMediaWidget extends StatefulWidget {
  final Media e;
  final List<Media> galleryItems;
  const ProductMediaWidget({
    super.key,
    required this.e,
    required this.galleryItems,
  });

  @override
  State<ProductMediaWidget> createState() => _ProductMediaWidgetState();
}

class _ProductMediaWidgetState extends State<ProductMediaWidget> {
  late VideoPlayerController videoPlayerController;
  late PodPlayerController controller;
  bool isVideoPrepire = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    if (!isVideoPrepire) {
      if (videoPlayerController.value.isInitialized) {
        videoPlayerController.dispose();
      }
      if (controller.isInitialised) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Uint8List? videoFile;
  init() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.e.name ?? ''),
    );
    await videoPlayerController.initialize();

    if ((widget.e.contentType ?? '').toLowerCase().contains('video')) {
      controller = PodPlayerController(
          playVideoFrom: PlayVideoFrom.network(
            widget.e.name ?? '',
          ),
          podPlayerConfig: const PodPlayerConfig(
            autoPlay: false,
            isLooping: false,
          ))
        ..initialise().catchError((onError) {
          log('videoError: $onError');
        });

      videoFile = await VideoThumbnail.thumbnailData(
        video: widget.e.name ?? '',
        imageFormat: ImageFormat.JPEG,
        maxHeight: 400,
        quality: 100,
      );
      isVideoPrepire = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.e.contentType ?? '').toLowerCase().contains('image')
        ? InkWell(
            onTap: () {
              Get.to(() => MultiImagePreview(
                    galleryItems: widget.galleryItems
                        .where((e) => (e.contentType ?? '').toLowerCase().contains('image'))
                        .toList(),
                    initialIndex: 0,
                  ));
            },
            child: NetworkImagePreview(
              radius: 0.r,
              url: widget.e.name ?? '',
              height: 90.h,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          )
        : InkWell(
            onTap: () {
              showVideoDialog(
                context,
                controller: controller,
                videoPlayerController: videoPlayerController,
              ).then((onValue) {
                if (controller.isInitialised) {
                  controller.pause();
                }
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                videoFile == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Please Wait...  ',
                            style: TextStyle(color: Colors.black26),
                          ),
                          CupertinoActivityIndicator(
                            radius: 8.r,
                          ),
                        ],
                      )
                    : Image.memory(
                        videoFile!,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                videoFile == null
                    ? const Center()
                    : Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.w,
                          ),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 35.r,
                          color: AppColors.scaffoldBackgroundColor,
                        ),
                      ),
              ],
            ),
          );
  }
}

Future showVideoDialog(
  BuildContext context, {
  required VideoPlayerController videoPlayerController,
  required PodPlayerController controller,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true, // Allows closing the dialog by tapping outside
    builder: (BuildContext context) {
      return SizedBox(
        width: Get.width,
        height: Get.height,
        child: PodVideoPlayer(
          videoAspectRatio: videoPlayerController.value.aspectRatio,
          controller: controller,
          onLoading: (context) => const CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ),
      );
    },
  );
}

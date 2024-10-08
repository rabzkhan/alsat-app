import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProductController extends GetxController {
  RxBool isShowPostProductVideo = RxBool(false);
  RxList<File> pickImageList = RxList([]);
  RxList<File> pickVideoList = RxList([]);
  RxList<Uint8List?> videoThumbnails = <Uint8List?>[].obs;
  Rxn<TimeOfDay> fromTime = Rxn<TimeOfDay>();
  Rxn<TimeOfDay> toTime = Rxn<TimeOfDay>();

  // PICK IMAGE FOR POST PRODUCT
  Future<void> pickImage(BuildContext context) async {
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
        ));
    if (pickImage != null) {
      for (AssetEntity imagePick in pickImage) {
        File? file = await imagePick.file;
        if (file != null) {
          pickImageList.add(file);
        }
        update();
      }
    }
  }

  // PICK VIDEO FOR POST PRODUCT
  Future<void> pickVideo(BuildContext context) async {
    List<AssetEntity>? pickVideo = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.video,
        ));
    if (pickVideo != null) {
      for (AssetEntity videoPick in pickVideo) {
        File? file = await videoPick.file;
        if (file != null) {
          pickVideoList.add(file);
        }
        videoThumbnails.clear();
        _generateThumbnails();
        update();
      }
    }
  }

  Future<void> _generateThumbnails() async {
    for (var videoFile in pickVideoList) {
      try {
        final thumbnailData = await VideoThumbnail.thumbnailData(
          video: videoFile.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 150,
          quality: 75,
        );
        videoThumbnails.add(thumbnailData);
      } catch (e) {
        log('Error generating thumbnail: $e');
      }
    }
  }

  Future<TimeOfDay?> showUserTimePickerDialog(BuildContext context) async {
    TimeOfDay? selectTime = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    return selectTime;
  }
}

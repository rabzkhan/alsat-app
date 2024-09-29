import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProductController extends GetxController {
  RxBool isShowPostProductVideo = RxBool(false);
  RxList<File> pickImageList = RxList([]);
  RxList<File> pickVideoList = RxList([]);

  // PICK IMAGE FOR POST PRODUCT
  Future<void> pickImage(BuildContext context) async {
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
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
        pickerConfig: AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.video,
        ));
    if (pickVideo != null) {
      for (AssetEntity videoPick in pickVideo) {
        File? file = await videoPick.file;
        if (file != null) {
          pickVideoList.add(file);
        }
        update();
      }
    }
  }
}

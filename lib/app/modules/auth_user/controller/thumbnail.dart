import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class ThumbnailService extends GetxController {
  final thumbnails = <String, Uint8List?>{}.obs;
  final loading = <String, bool>{}.obs;

  Future<void> loadThumbnail(String videoPath) async {
    if (thumbnails.containsKey(videoPath) || loading[videoPath] == true) return;

    loading[videoPath] = true;

    try {
      final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      thumbnails[videoPath] = thumbnail;
    } catch (e) {
      print("Thumbnail generation failed for $videoPath: $e");
      thumbnails[videoPath] = null;
    } finally {
      loading[videoPath] = false;
    }
  }
}

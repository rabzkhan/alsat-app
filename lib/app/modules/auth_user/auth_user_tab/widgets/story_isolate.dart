import 'dart:isolate';

import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'dart:typed_data';

void isolateEntry(dynamic message) async {
  final Map<String, dynamic> args = message;
  final String videoPath = args['videoPath'];
  final SendPort sendPort = args['sendPort'];

  final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
  );

  sendPort.send(thumbnail);
}

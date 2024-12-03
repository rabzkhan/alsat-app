import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final localLanguage = AppLocalizations.of(Get.context!)!;
String timeAgo(DateTime date) {
  final clock = DateTime.now();
  var elapsed = clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  if (seconds < 45) {
    return "${seconds.round()}s ago";
  } else if (seconds < 90) {
    return "Minute ago";
  } else if (minutes < 45) {
    return "${minutes.round()} minutes ago";
  } else if (minutes < 90) {
    return "Hour ago";
  } else if (hours < 24) {
    return "${hours.round()} hours ago";
  } else if (hours < 48) {
    return "Day ago";
  } else if (days < 30) {
    return "${days.round()} days ago";
  } else if (days < 60) {
    return "Month ago";
  } else if (days < 365) {
    return "${months.round()} months ago";
  } else if (years < 1) {
    return "Year ago";
  } else {
    return "${years.round()} years ago";
  }
}

Future<Map<String, dynamic>> imageToBase64(String filePath) async {
  String base64String = await convertImageToBase64(filePath);
  String extension = path.extension(filePath).toLowerCase();
  String contentType;
  switch (extension) {
    case '.jpg':
    case '.jpeg':
      contentType = 'image/jpeg';
      break;
    case '.png':
      contentType = 'image/png';
      break;
    case '.gif':
      contentType = 'image/gif';
      break;
    case '.bmp':
      contentType = 'image/bmp';
      break;
    case '.webp':
      contentType = 'image/webp';
      break;
    default:
      contentType = 'application/octet-stream';
  }
  var jsonObject = {
    "name": base64String,
    "type": "image",
    "size": File(filePath).lengthSync(),
    "hash": calculateHash(base64String),
    "content_type": contentType
  };
  return jsonObject;
}

String calculateHash(String base64String) {
  return base64String.hashCode.toString();
}

Future<String> convertImageToBase64(String filePath) async {
  File imageFile = File(filePath);
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

//
Future<String> convertFileToBase64(String filePath) async {
  final bytes = await File(filePath).readAsBytes();
  return base64Encode(bytes);
}

Future<Map<String, dynamic>> videoToBase64(String filePath) async {
  String base64String = await convertFileToBase64(filePath);
  String extension = path.extension(filePath).toLowerCase();
  String contentType;

  // Determine content type based on file extension
  switch (extension) {
    case '.mp4':
      contentType = 'video/mp4';
      break;
    case '.avi':
      contentType = 'video/x-msvideo';
      break;
    case '.mov':
      contentType = 'video/quicktime';
      break;
    case '.mkv':
      contentType = 'video/x-matroska';
      break;
    case '.webm':
      contentType = 'video/webm';
      break;
    default:
      contentType = 'application/octet-stream';
  }

  // Creating a JSON object for the video
  var jsonObject = {
    "name": base64String,
    "type": "video",
    "size": File(filePath).lengthSync(),
    "hash": calculateHash(base64String),
    "content_type": contentType
  };

  return jsonObject;
}

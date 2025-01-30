import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/message_model.dart';

class MapMessage extends StatelessWidget {
  const MapMessage({
    super.key,
    this.message,
    this.isReply = false,
  });
  final bool isReply;

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        openMap(message?.data[0].toDouble(), message?.data[1].toDouble());
      },
      child: Container(
        width: Get.width * .7,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0 * 0.75,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isReply
              ? Colors.transparent
              : message!.isSender
                  ? context.theme.primaryColor.withOpacity(.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: !message!.isSender
                ? Colors.black26
                : context.theme.primaryColor.withOpacity(.4),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: IgnorePointer(
                ignoring: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(message?.data[0].toDouble(),
                          message?.data[1].toDouble()),
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
                  ),
                ),
              ),
            ),
            5.verticalSpace,
            Text(
              DateFormat('hh:mm').format(message!.time.toLocal()),
              style: context.theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: message!.isSender ? Get.theme.primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/?q=$latitude,$longitude';
    log('url: $url');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }
}

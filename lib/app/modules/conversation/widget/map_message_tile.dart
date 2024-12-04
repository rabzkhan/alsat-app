import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../model/message_model.dart';

class MapMessage extends StatelessWidget {
  const MapMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .7,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: message!.isSender
            ? context.theme.primaryColor.withOpacity(.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
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
            DateFormat('hh:mm').format(message!.time),
            style: context.theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

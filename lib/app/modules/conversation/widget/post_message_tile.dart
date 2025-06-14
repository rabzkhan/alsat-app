import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../../components/prepost_loading.dart';
import '../model/message_model.dart';

class PostMessageTile extends StatelessWidget {
  const PostMessageTile({
    super.key,
    this.message,
    this.isReply = false,
  });
  final bool isReply;

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return message?.data['_id'] == null || (message?.data['_id'].toString())!.isEmpty
        ? const Center()
        : InkWell(
            onTap: () {
              Get.to(
                () => PrePostLoading(
                  postId: (message?.data["_id"]).toString(),
                ),
                transition: Transition.fade,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0 * 0.75,
                vertical: 5,
              ),
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                color: isReply
                    ? Colors.transparent
                    : message!.isSender
                        ? (context.theme.primaryColor.withOpacity(.4))
                        : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: (message?.data?['media']).isEmpty
                            ? Container(
                                height: 50.h,
                                width: 60.h,
                                color: Colors.grey.shade300,
                              )
                            : NetworkImagePreview(
                                radius: 10.r,
                                url: (message?.data?['media']).toList().first['name'] ?? "",
                                height: 50.h,
                                width: 60.h,
                                fit: BoxFit.cover,
                                // fit: BoxFit.cover,
                              ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RichText(
                                  maxLines: 1,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: message?.data['title'] ?? 'Hyundai santa fe ',
                                      style: regular.copyWith(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ])),
                              4.verticalSpace,
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: "${message?.data['price_info']['price'] ?? '00'} TMT",
                                  style: bold.copyWith(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ])),
                              Text(
                                '${message?.data['location_province'] ?? ''} ${message?.data['location_city'] ?? ''}',
                                style: regular.copyWith(
                                  fontSize: 11.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  5.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message?.text ?? '',
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm').format(message!.time),
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: isReply
                              ? Colors.black
                              : message!.isSender
                                  ? Colors.white
                                  : null,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

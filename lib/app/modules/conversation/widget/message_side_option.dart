import 'package:alsat/app/common/const/image_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../authentication/controller/auth_controller.dart';
import '../../product/controller/product_details_controller.dart';
import '../../product/view/client_profile_view.dart';
import '../controller/conversation_controller.dart';
import '../model/conversation_messages_res.dart';
import 'user_block_bottom_sheet.dart';
import 'user_report_bottom_sheet.dart';

class MessageSideOption extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold;
  final Participant? participant;
  final ConversationController conversationController;
  final AuthController authController;
  final Function() onBlock;
  const MessageSideOption(this.scaffold,
      {super.key,
      required this.participant,
      required this.conversationController,
      required this.authController,
      required this.onBlock});

  @override
  Widget build(BuildContext context) {
    Participant? participant = conversationController
        .selectConversation.value?.participants
        ?.firstWhereOrNull(
            (e) => e.id != authController.userDataModel.value.id);
    return SafeArea(
      child: Container(
        width: Get.width * .5,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            10.verticalSpace,
            CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.grey.shade300,
              child: NetworkImagePreview(
                radius: 49.r,
                url: participant?.picture ?? "",
                height: 80.h,
                error: Image.asset(userDefaultIcon),
              ),
            ),
            10.verticalSpace,
            Text(
              '${participant?.userName}',
              style: bold.copyWith(
                fontSize: 15.sp,
              ),
            ),
            10.verticalSpace,
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  textStyle: regular.copyWith(
                    fontSize: 13.sp,
                    color: Colors.black87,
                  )),
              onPressed: () {
                Get.back();
                ProductDetailsController productDetailsController =
                    Get.put(ProductDetailsController(), tag: participant?.id);

                productDetailsController.isFetchUserLoading.value = false;
                Get.to(
                  () => ClientProfileView(
                    userId: (participant?.id ?? '').toString(),
                    productDetailsController: productDetailsController,
                  ),
                  transition: Transition.fadeIn,
                );
              },
              child: Text(
                'Profile',
                style: regular.copyWith(
                  fontSize: 13.sp,
                  color: Colors.black,
                ),
              ),
            ),
            CupertinoListTile.notched(
              onTap: () {
                // Get.back();
                showUserBlockBottomSheet(
                  participant: participant!,
                  conversationController: conversationController,
                ).then((onValue) {
                  onBlock();
                });
              },
              title: Text(
                'Block User',
                style: regular.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              leading: const Icon(
                Icons.block_rounded,
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
            CupertinoListTile.notched(
              onTap: () {
                // Get.back();
                showUserReportBottomSheet(
                  participant: participant!,
                  conversationController: conversationController,
                );
              },
              title: Text(
                'Report',
                style: regular.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              leading: const Icon(
                Icons.report,
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}

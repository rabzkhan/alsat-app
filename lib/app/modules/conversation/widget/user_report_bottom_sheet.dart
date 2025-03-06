import 'dart:developer';

import 'package:alsat/app/modules/conversation/model/conversation_messages_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../controller/conversation_controller.dart';

showUserReportBottomSheet(
    {required Participant participant,
    required ConversationController conversationController}) {
  final localLanguage = AppLocalizations.of(Get.context!)!;

  return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.1),
      context: Get.context!,
      builder: (context) {
        return SingleChildScrollView(
          child: FormBuilder(
            key: conversationController.reportFromKey,
            child: Builder(builder: (context) {
              double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
                  bottom: keyboardHeight,
                ),
                height: Get.height * .6 + keyboardHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    20.verticalSpace,
                    Image.asset(
                      'assets/icons/report.png',
                      height: 60.h,
                    ),
                    25.verticalSpace,
                    FormBuilderTextField(
                      name: 'reason',
                      decoration: InputDecoration(
                        isDense: true,
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: localLanguage.report_reason,
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Get.theme.shadowColor.withOpacity(.6),
                        ),
                        border: outlineBorder,
                        enabledBorder: outlineBorder,
                        errorBorder: outlineBorder,
                        focusedBorder: outlineBorder,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    10.verticalSpace,
                    FormBuilderTextField(
                      name: 'description',
                      maxLines: 4,
                      minLines: 4,
                      decoration: InputDecoration(
                        isDense: true,
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: localLanguage.report_description,
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Get.theme.shadowColor.withOpacity(.6),
                        ),
                        border: outlineBorder,
                        enabledBorder: outlineBorder,
                        errorBorder: outlineBorder,
                        focusedBorder: outlineBorder,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    20.verticalSpace,
                    CupertinoButton(
                      color: Colors.red,
                      onPressed: conversationController.isReport.value
                          ? null
                          : () {
                              if (conversationController
                                  .reportFromKey.currentState!
                                  .saveAndValidate()) {
                                log('${conversationController.reportFromKey.currentState?.value}');
                                conversationController.sendReport({
                                  "reported_id": participant.id,
                                  "reason": conversationController.reportFromKey
                                      .currentState!.value['reason'],
                                  "description": conversationController
                                      .reportFromKey
                                      .currentState!
                                      .value['description']
                                });
                                // Get.back();
                              }
                            },
                      child: Obx(() {
                        return conversationController.isReport.value
                            ? const CupertinoActivityIndicator(
                                color: Colors.white)
                            : Text(
                                localLanguage.report,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              );
                      }),
                    ),
                    10.verticalSpace,
                    CupertinoButton(
                      child: Text(
                        localLanguage.cancel,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      });
}

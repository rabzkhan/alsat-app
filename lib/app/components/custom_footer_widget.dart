import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:alsat/l10n/app_localizations.dart';
import '../../config/theme/app_text_theme.dart';

class CustomFooterWidget extends StatelessWidget {
  const CustomFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(
            localLanguage.pull_up_load,
            style: regular,
          );
        } else if (mode == LoadStatus.loading) {
          body = CircularProgressIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(
            localLanguage.load_failed,
            style: regular,
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text(
            localLanguage.release_to_load_more,
            style: regular,
          );
        } else {
          body = Text(
            localLanguage.no_more_data,
            style: regular,
          );
        }
        return SizedBox(
          height: 55.h,
          child: Center(child: body),
        );
      },
    );
  }
}

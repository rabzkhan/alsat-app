import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/filter/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/translations/localization_service.dart';
import '../common/const/image_path.dart';

class CustomAppBar extends StatelessWidget {
  final bool isShowSearch;
  final bool isShowLogo;
  final bool isShowFilter;
  final bool isShowNotification;
  final bool isShowBackButton;
  final Widget? action;
  final Widget? title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const CustomAppBar({
    super.key,
    this.isShowSearch = true,
    this.isShowFilter = true,
    this.isShowNotification = true,
    this.isShowBackButton = false,
    this.action,
    this.isShowLogo = true,
    this.scaffoldKey,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 65.h,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Row(
        children: [
          !isShowBackButton
              ? scaffoldKey == null
                  ? const Center()
                  : IconButton(
                      onPressed: () {
                        scaffoldKey!.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    )
              : const BackButton(),
          4.horizontalSpace,
          const Spacer(),
          if (isShowLogo) title ?? Image.asset(logo),
          const Spacer(),
          if (!isShowFilter && !isShowSearch) const Spacer(),
          action ?? const Center(),
          // I
        ],
      ),
    );
  }
}

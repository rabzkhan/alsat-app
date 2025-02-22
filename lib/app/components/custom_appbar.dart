import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: 60.h,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ).copyWith(bottom: 5.h),
      child: Row(
        children: [
          !isShowBackButton
              ? scaffoldKey == null
                  ? const Center()
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          scaffoldKey!.currentState?.openDrawer();
                        },
                        icon: Image.asset(
                          "assets/icons/menu.png",
                          height: 30.h,
                        ),
                      ),
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

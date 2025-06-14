// ignore_for_file: deprecated_member_use

import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../../components/product_grid_tile.dart';
import '../../conversation/view/message_view.dart';
import '../../story/component/story_video_player.dart';
import '../widget/rate_bottom_sheet.dart';

class ClientProfileView extends StatefulWidget {
  final String userId;
  final bool isFromMessage;
  final ProductDetailsController productDetailsController;
  const ClientProfileView(
      {super.key, required this.userId, this.isFromMessage = false, required this.productDetailsController});

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  AuthController authController = Get.find();
  @override
  void initState() {
    widget.productDetailsController.selectUserId = widget.userId;
    // if (widget.productDetailsController.userPostCategories.isEmpty) {
    //   widget.productDetailsController.getUserPostCategories();
    // }
    widget.productDetailsController.getUserPostCategories(userId: widget.userId);
    Future.microtask(() {
      widget.productDetailsController.isFetchUserLoading.value = true;
      widget.productDetailsController.getUserByUId(userId: widget.userId);
      widget.productDetailsController.getUserStory(widget.userId);
    });
    super.initState();
  }

  //--- Get All PRODUCT ---//
  RefreshController userProductRefreshController = RefreshController(initialRefresh: false);
  void userProductRefresh() async {
    await widget.productDetailsController.fetchUserProducts();
    userProductRefreshController.refreshCompleted();
  }

  void userProductLoading() async {
    if (widget.productDetailsController.userProductPostListRes?.hasMore ?? false) {
      await widget.productDetailsController
          .fetchUserProducts(nextPaginateDate: widget.productDetailsController.userProductList.last.createdAt);
    }
    userProductRefreshController.loadComplete();
  }

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white12,
            title: Text(""),
          ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: // // user information
                          Obx(() {
                        return Skeletonizer(
                          enabled: widget.productDetailsController.isFetchUserLoading.value,
                          // effect: ShimmerEffect(
                          //   baseColor: Get.theme.disabledColor.withOpacity(.2),
                          //   highlightColor: Colors.white,
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment.centerRight,
                          // ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ).copyWith(top: 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Obx(() {
                                      return widget.productDetailsController.userStoryList.isEmpty
                                          ? CircleAvatar(
                                              radius: 28.r,
                                              child: NetworkImagePreview(
                                                radius: 26.r,
                                                url: widget.productDetailsController.postUserModel.value?.picture ?? '',
                                                height: 52.h,
                                                width: 52.w,
                                                error: Image.asset(userDefaultIcon),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Stories(
                                              autoPlayDuration: const Duration(seconds: 10),
                                              highLightColor: AppColors.primary,
                                              paddingColor: AppColors.secondary,
                                              fullpageVisitedColor: AppColors.primary,
                                              fullpageUnisitedColor: AppColors.primary,
                                              storyStatusBarColor: Colors.white,
                                              circlePadding: 2,
                                              showStoryName: false,
                                              // addOption:,
                                              storyItemList: [
                                                StoryItem(
                                                  userId: "",
                                                  name: "",
                                                  thumbnail: NetworkImage(
                                                    widget.productDetailsController.userStoryList.first.user?.picture ??
                                                        '',
                                                  ),
                                                  stories: [
                                                    ...(widget.productDetailsController.userStoryList.first.stories ??
                                                            [])
                                                        .map(
                                                      (e) => StoryMainModel(
                                                        isVideo: (e.media?.type == "video" &&
                                                            e.media?.name != null &&
                                                            e.media!.name!.isNotEmpty),
                                                        url: e.media?.name ?? '',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                    }),
                                    15.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${widget.productDetailsController.postUserModel.value?.userName}',
                                                style: regular.copyWith(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              6.horizontalSpace,
                                              if (widget.productDetailsController.postUserModel.value?.premium ?? false)
                                                Icon(
                                                  Icons.verified,
                                                  size: 18.r,
                                                  color: Get.theme.primaryColor,
                                                ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 14.r,
                                                color: (widget.productDetailsController.postUserModel.value
                                                            ?.protectionLabel ??
                                                        false)
                                                    ? Colors.green
                                                    : Get.theme.disabledColor.withOpacity(.1),
                                              ),
                                              3.horizontalSpace,
                                              Text(
                                                localLanguage.buyer_protection,
                                                style: (widget.productDetailsController.postUserModel.value
                                                            ?.protectionLabel ??
                                                        false)
                                                    ? regular.copyWith(
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w600,
                                                        fontStyle: FontStyle.italic,
                                                      )
                                                    : regular.copyWith(
                                                        fontSize: 12.sp,
                                                        color: Get.theme.disabledColor.withOpacity(0.2),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          6.verticalSpace,
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RatingBarIndicator(
                                                rating:
                                                    (widget.productDetailsController.postUserModel.value?.rating ?? 0)
                                                        .toDouble(),
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.star_border_outlined,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 15.r,
                                                direction: Axis.horizontal,
                                              ),
                                              3.horizontalSpace,
                                              Text(
                                                '(${(widget.productDetailsController.postUserModel.value?.rating ?? 0).toStringAsFixed(1)}) ${(widget.productDetailsController.postUserModel.value?.votes ?? 0)}',
                                                style: regular.copyWith(
                                                  fontSize: 12.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${widget.productDetailsController.postUserModel.value?.followers ?? 0}',
                                          style: bold.copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Text(
                                          localLanguage.followers,
                                          style: regular.copyWith(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.horizontalSpace,
                                  ],
                                ),
                                //-- Follow and chat buttons--//

                                if (widget.productDetailsController.postUserModel.value?.bio?.isNotEmpty ?? false)
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      textAlign: TextAlign.justify,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      '${widget.productDetailsController.postUserModel.value?.bio}',
                                      style: regular.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                (authController.userDataModel.value.id ==
                                            widget.productDetailsController.postUserModel.value?.id) ||
                                        authController.userDataModel.value.id == null
                                    ? const Center()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Obx(() {
                                              return Skeletonizer(
                                                enabled: widget.productDetailsController.isFetchUserLoading.value,
                                                // effect: ShimmerEffect(
                                                //   baseColor: Get.theme.disabledColor.withOpacity(.2),
                                                //   highlightColor: Colors.white,
                                                //   begin: Alignment.centerLeft,
                                                //   end: Alignment.centerRight,
                                                // ),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    widget.productDetailsController.isFetchUserLoading.value = true;
                                                    widget.productDetailsController.followingAUser(
                                                      userId:
                                                          widget.productDetailsController.postUserModel.value?.id ?? '',
                                                      isFollow: !(widget
                                                              .productDetailsController.postUserModel.value?.followed ??
                                                          false),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor: (widget.productDetailsController.postUserModel
                                                                .value?.followed ??
                                                            false)
                                                        ? context.theme.disabledColor.withOpacity(.5)
                                                        : Theme.of(context).primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12.r),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    (widget.productDetailsController.postUserModel.value?.followed ??
                                                            false)
                                                        ? localLanguage.unfollow
                                                        : localLanguage.follow,
                                                    style: regular.copyWith(
                                                      color: Get.theme.scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed:
                                                  widget.productDetailsController.isFetchUserConversationLoading.value
                                                      ? null
                                                      : () {
                                                          widget.isFromMessage
                                                              ? Get.back()
                                                              : widget.productDetailsController
                                                                  .getConversationInfoByUserId(widget
                                                                          .productDetailsController
                                                                          .postUserModel
                                                                          .value
                                                                          ?.id ??
                                                                      "")
                                                                  .then((value) {
                                                                  Get.to(
                                                                    MessagesScreen(
                                                                      conversation: widget.productDetailsController
                                                                          .conversationInfo.value!,
                                                                    ),
                                                                    transition: Transition.fadeIn,
                                                                  );
                                                                });
                                                        },
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Get.theme.primaryColor,
                                                ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                ),
                                              ),
                                              child:
                                                  widget.productDetailsController.isFetchUserConversationLoading.value
                                                      ? const CupertinoActivityIndicator()
                                                      : Text(
                                                          localLanguage.message,
                                                          style: regular.copyWith(
                                                            color: Get.theme.primaryColor,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          InkWell(
                                            onTap: () {
                                              showRateBottomSheet(context, widget.productDetailsController);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Get.theme.primaryColor, // Set border color
                                                ),
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 5,
                                                ),
                                                child: Icon(
                                                  Icons.star_border_outlined,
                                                  color: Colors.amber,
                                                  size: 25.r,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  ],
              body: Obx(() {
                if (widget.productDetailsController.userPostCategories.isEmpty) {
                  return SizedBox();
                }
                return DefaultTabController(
                  initialIndex: widget.productDetailsController.isUserPostCategoryLoading.value
                      ? 0
                      : widget.productDetailsController.selectCategory.value == null
                          ? 0
                          : (widget.productDetailsController.userPostCategories
                              .indexOf(widget.productDetailsController.selectCategory.value)),
                  length: widget.productDetailsController.userPostCategories.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return TabBar(
                          onTap: (value) {
                            widget.productDetailsController.selectCategory.value =
                                widget.productDetailsController.userPostCategories[value];
                            userProductRefresh();
                          },
                          isScrollable: true,
                          unselectedLabelColor: Colors.black87,
                          indicatorWeight: 1,
                          indicator: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: context.theme.primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                          tabs: widget.productDetailsController.userPostCategories
                              .map(
                                (e) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
                                  child: Text(
                                    e.name ?? '',
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                      14.verticalSpace,
                      Expanded(
                        child: Obx(
                          () {
                            return SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              header: CustomHeaderWidget(),
                              footer: CustomFooterWidget(),
                              controller: userProductRefreshController,
                              onRefresh: userProductRefresh,
                              onLoading: userProductLoading,
                              child: !widget.productDetailsController.isFetchUserProduct.value &&
                                      widget.productDetailsController.userProductList.isEmpty
                                  ? NoDataWidget(
                                      title: 'No Product Found',
                                      bottomHeight: 100.h,
                                    )
                                  : GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10.h,
                                        crossAxisSpacing: 10.w,
                                        mainAxisExtent: 200.h,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ProductGridTile(
                                          isFromMessage: widget.isFromMessage,
                                          loading: widget.productDetailsController.isFetchUserProduct.value,
                                          productModel: widget.productDetailsController.isFetchUserProduct.value
                                              ? null
                                              : widget.productDetailsController.userProductList[index],
                                        );
                                      },
                                      itemCount: widget.productDetailsController.isFetchUserProduct.value
                                          ? 10
                                          : widget.productDetailsController.userProductList.length,
                                    ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              })),
        ),
      ),
    );
  }
}

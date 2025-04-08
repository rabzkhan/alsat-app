import 'dart:developer';
import 'dart:ui';

import 'package:alsat/app/modules/app_home/controller/home_controller.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/conversation/model/conversations_res.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/app/modules/product/model/product_post_list_res.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_snackbar.dart';
import '../../../services/base_client.dart';
import '../../app_home/models/category_model.dart';
import '../../authentication/model/user_data_model.dart';
import '../../story/model/story_res.dart';
import '../model/product_post_res.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsController extends GetxController {
  Rxn<CategoriesModel> selectCategory = Rxn<CategoriesModel>(null);
  CarouselSliderController carouselSliderController = CarouselSliderController();
  RxInt carouselCurrentIndex = 0.obs;
  //-- get Product Like Count --//

  @override
  void onInit() {
    HomeController homeController = Get.find();
    selectCategory.value = homeController.categories.firstOrNull;
    super.onInit();
  }

  RxnNum likeCount = RxnNum(0);
  RxBool isProductLike = RxBool(true);
  Future<void> productLikeCount({required String productId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/likes/count",
      DioRequestType.get,
      onLoading: () {
        isProductLike.value = true;
        likeCount.value = 0;
      },
      onSuccess: (response) {
        likeCount.value = response.data['count'];
        isProductLike.value = false;
      },
      onError: (p0) {
        isProductLike.value = false;
      },
    );
  }

  //-- get Product Like Count --//
  RxnNum commentCount = RxnNum(0);
  RxBool isProductComment = RxBool(true);
  Future<void> productCommentCount({required String productId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment/count",
      DioRequestType.get,
      onLoading: () {
        isProductComment.value = true;
        commentCount.value = 0;
      },
      onSuccess: (response) {
        commentCount.value = response.data['count'];
        isProductComment.value = false;
      },
      onError: (p0) {
        isProductComment.value = false;
      },
    );
  }

  //-- get Product view Count --//
  RxnNum viewCount = RxnNum(0);
  RxBool isProductView = RxBool(true);
  Future<void> productViewCount({required String productId, required String productCreateTime}) async {
    log("${Constants.baseUrl}${Constants.postProduct}/$productId/views/count?since=$productCreateTime");
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/views/count?since=$productCreateTime",
      DioRequestType.get,
      onLoading: () {
        isProductView.value = true;
        viewCount.value = 0;
      },
      onSuccess: (response) {
        viewCount.value = response.data['count'];
        isProductView.value = false;
      },
      onError: (p0) {
        isProductView.value = false;
      },
    );
  }

  Future<void> productViewCountAdding({required String productId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/views",
      DioRequestType.post,
      onLoading: () {},
      onSuccess: (response) {
        log("${response.data}");
      },
      onError: (p0) {
        log(p0.toString());
      },
    );
  }

  //-- get product comment list--//
  Rxn<ProudctPostCommentRes> productCommentListRes = Rxn<ProudctPostCommentRes>();
  RxList<CommentModel> productCommentList = RxList<CommentModel>();
  RxBool isProductCommentList = RxBool(true);
  Future<void> getProductComments({required String productId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment",
      DioRequestType.get,
      onLoading: () {
        isProductCommentList.value = true;
        productCommentList.clear();
      },
      onSuccess: (response) {
        log("${response.data}");
        Map<String, dynamic> data = response.data;
        productCommentListRes.value = ProudctPostCommentRes.fromJson(data);
        productCommentList.value = productCommentListRes.value?.data ?? [];

        isProductCommentList.value = false;
      },
      onError: (p0) {
        isProductCommentList.value = false;
      },
    );
  }

  //-- Add Product Comment --//
  RxBool isProductCommentAdd = RxBool(false);

  Future<void> addProductComment({required String productId, required String comment}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment",
      DioRequestType.post,
      data: {"content": comment},
      onLoading: () {
        FocusScope.of(Get.context!).unfocus();
        isProductCommentAdd.value = true;
      },
      onSuccess: (response) {
        getProductComments(productId: productId);
        isProductCommentAdd.value = false;
      },
      onError: (e) {
        if (e.response?.data['result'] != null) {
          CustomSnackBar.showCustomToast(message: e.response?.data['result']);
        }
        isProductCommentAdd.value = false;
      },
    );
  }

  //-- get User by User Id --//
  Rxn<UserDataModel> postUserModel = Rxn<UserDataModel>();
  RxBool isFetchUserLoading = RxBool(true);
  Future<void> getUserByUId({required String userId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.user}/$userId",
      DioRequestType.get,
      onLoading: () {},
      onSuccess: (response) {
        Map<String, dynamic> data = response.data;
        log("User data is:  ${response.data}");
        postUserModel.value = UserDataModel.fromJson(data);
        selectUserId = postUserModel.value?.id ?? '';

        isFetchUserLoading.value = false;
      },
      onError: (p0) {
        log('${p0.response?.data} ${"${Constants.baseUrl}${Constants.user}/$userId"}');
        isFetchUserLoading.value = false;
      },
    );
  }

  RxBool isFetchProductInsights = RxBool(false);
  RxList productInsightsList = RxList();
  Future<void> getProductInsights({required String pId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$pId/views/count-by-province",
      DioRequestType.get,
      onLoading: () {
        productInsightsList.clear();
        isFetchProductInsights.value = true;
      },
      onSuccess: (response) {
        productInsightsList.value = response.data;
        log("isFetchProductInsights ${response.data}");
        isFetchProductInsights.value = false;
      },
      onError: (p0) {
        isFetchProductInsights.value = false;
      },
    );
  }

  RxList<CategoriesModel> userPostCategories = <CategoriesModel>[].obs;

  RxBool isUserPostCategoryLoading = false.obs;
  getUserPostCategories({required String userId}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}/posts/categories?user_id=$userId",
      DioRequestType.get,
      onLoading: () {
        isUserPostCategoryLoading.value = true;
      },
      onSuccess: (response) async {
        List<dynamic> data = response.data;
        userPostCategories.value = data.map((json) => CategoriesModel.fromJson(json)).toList();
        log('userPostCategories: ${userPostCategories.length}');
        selectCategory.value = userPostCategories.first;
        fetchUserProducts();
        isUserPostCategoryLoading.value = false;
      },
      onError: (error) {
        isUserPostCategoryLoading.value = false;
      },
    );
  }

  //--- Get User PRODUCT ---//

  RxBool isFetchUserProduct = RxBool(true);
  RxList<ProductModel> userProductList = RxList<ProductModel>();
  ProductPostListRes? userProductPostListRes;
  String selectUserId = '';
  Future<void> fetchUserProducts({String? nextPaginateDate}) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?next=$nextPaginateDate&user=${postUserModel.value?.id ?? selectUserId}';
    } else {
      url = "$url?user=${postUserModel.value?.id ?? selectUserId}";
    }
    Map<String, dynamic> data = selectCategory.value != null ? {"category_id": selectCategory.value!.sId ?? ""} : {};

    await BaseClient().safeApiCall(
      url,
      DioRequestType.get,
      data: data,
      onLoading: () {
        if (nextPaginateDate == null) {
          isFetchUserProduct.value = true;
          userProductList.clear();
        }
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        Map<String, dynamic> responseData = response.data;
        userProductPostListRes = ProductPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          userProductList.addAll(userProductPostListRes?.data ?? []);
        } else {
          userProductList.value = userProductPostListRes?.data ?? [];
        }
        isFetchUserProduct.value = false;
      },
      onError: (p0) {
        isFetchUserProduct.value = false;
        CustomSnackBar.showCustomToast(message: localLanguage.product_fetching_failed);
      },
    );
  }

  //-- Rate User --//
  RxBool isRateUserLoading = RxBool(false);
  RxDouble userRate = RxDouble(3);
  Future<void> rateUser() async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.user}/$selectUserId/rate",
      DioRequestType.post,
      data: {"stars": userRate.value},
      onLoading: () {
        isRateUserLoading.value = true;
      },
      onSuccess: (response) {
        isRateUserLoading.value = false;
        Get.back();
        // CustomSnackBar.showCustomToast(
        //     message: localLanguage.rate_successfully);
        getUserByUId(userId: selectUserId);
      },
      onError: (p0) {
        log('${p0.message} ${"${Constants.baseUrl}${Constants.user}/$selectUserId/rate"}');
        isRateUserLoading.value = false;
        CustomSnackBar.showCustomToast(message: localLanguage.rate_failed);
      },
    );
  }

  //-Get Product Details --//
  RxBool isProductDetailsLoading = RxBool(true);
  Rxn<ProductModel> selectPostProductModel = Rxn<ProductModel>();
  Future<void> getSingleProductDetails(String pId) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$pId",
      DioRequestType.get,
      onLoading: () {
        isProductDetailsLoading.value = true;
        selectPostProductModel.value = null;
      },
      onSuccess: (response) {
        Map<String, dynamic> data = response.data;
        selectPostProductModel.value = ProductModel.fromJson(data);
        isProductDetailsLoading.value = false;
      },
      onError: (p0) {
        log('${p0.message} ${"${Constants.baseUrl}${Constants.postProduct}/$pId"}');
        isProductDetailsLoading.value = false;
      },
    );
  }

  //--follow user--//
  RxBool isFollowUserLoading = RxBool(false);
  Future<void> followingAUser({
    required String userId,
    required bool isFollow,
  }) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    AuthController authController = Get.find();
    selectUserId = userId;
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.user}/follow",
      DioRequestType.post,
      data: {
        "follower_id": authController.userDataModel.value.id,
        "user_id": userId,
        "follow": isFollow,
      },
      onLoading: () {
        isRateUserLoading.value = true;
      },
      onSuccess: (response) {
        log("Follow Successfully: ${response.data} ${response.requestOptions.data}-- $selectUserId");
        isRateUserLoading.value = false;
        CustomSnackBar.showCustomToast(
            message: '${!isFollow ? localLanguage.unfollow : localLanguage.follow} ${localLanguage.successfully}');
        getUserByUId(userId: selectUserId);
      },
      onError: (p0) {
        var data = {
          "follower_id": authController.userDataModel.value.id,
          "user_id": userId,
          "follow": isFollow,
        };

        isRateUserLoading.value = false;
        isFetchUserLoading.value = true;
        CustomSnackBar.showCustomToast(message: 'Follow Failed');
      },
    );
  }

  //--Get User Conversation Info--//
  Rxn<ConversationModel> conversationInfo = Rxn<ConversationModel>();
  RxBool isFetchUserConversationLoading = RxBool(false);
  Future<void> getConversationInfoByUserId(String userId) async {
    log("${Constants.baseUrl}/chats?user=$userId");
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}/chats?user=$userId",
      DioRequestType.get,
      onLoading: () {
        isFetchUserConversationLoading.value = true;
      },
      onSuccess: (response) {
        Map<String, dynamic> data = response.data;
        ConversationListRes conversationListRes = ConversationListRes.fromJson(data);
        conversationInfo.value = conversationListRes.data?.firstOrNull;
        isFetchUserConversationLoading.value = false;
      },
      onError: (p0) {
        final localLanguage = AppLocalizations.of(Get.context!)!;
        isFetchUserConversationLoading.value = false;
        CustomSnackBar.showCustomToast(message: localLanguage.failed_to_get_conversation_info);
      },
    );
  }

  ///--Get User User Story--//
  RxBool isFetchUserStoryLoading = RxBool(false);
  RxList<StoryModel> userStoryList = RxList<StoryModel>();
  Future<void> getUserStory(String userId) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.stories}?user_id=$userId",
      DioRequestType.get,
      onLoading: () {
        isFetchUserStoryLoading.value = true;
        userStoryList.clear();
      },
      onSuccess: (response) async {
        List<dynamic> data = response.data;
        userStoryList.value = data.map((json) => StoryModel.fromJson(json)).toList();
        isFetchUserStoryLoading.value = false;
        userStoryList.refresh();
        log('fetchUserStory: ${userStoryList.length}');
      },
      onError: (error) {
        log('fetchUserStoryError: ${error.message}');
        isFetchUserStoryLoading.value = false;
        userStoryList.refresh();
      },
    );
  }

  RxBool isDeletingPost = false.obs;

  Future<void> deleteUserPost({required String postId}) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    return Get.dialog(
      Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20).r,
              color: Colors.white,
            ),
            child: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.verticalSpace,
                  Text(
                    "Delete Post ?",
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    "Are you sure you want to delete this post?",
                    textAlign: TextAlign.center,
                    style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(),
                  ),
                  20.verticalSpace,
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Get.theme.primaryColor.withOpacity(.1),
                              side: BorderSide(
                                color: Get.theme.primaryColor,
                                width: 1,
                              ),
                              fixedSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: regular.copyWith(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size.fromHeight(48),
                              backgroundColor: Get.theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: () async {
                              Get.back(); // Close dialog before API call
                              isDeletingPost.value = true;
                              await BaseClient().safeApiCall(
                                "${Constants.baseUrl}${Constants.postProduct}/$postId",
                                DioRequestType.delete,
                                onSuccess: (response) {
                                  CustomSnackBar.showCustomToast(message: localLanguage.post_deleted_successfully);
                                  isDeletingPost.value = false;

                                  Get.find<ProductController>().fetchProducts();
                                  Get.find<HomeController>().fetchMyProducts();
                                  Get.back();
                                },
                                onError: (error) {
                                  log('Failed to delete post: $error');
                                  CustomSnackBar.showCustomToast(
                                    message: localLanguage.failed_to_delete_post,
                                    color: Colors.red,
                                  );
                                  isDeletingPost.value = false;
                                },
                              );
                            },
                            child: Text(
                              "Yes",
                              style: regular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/model/product_post_list_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_snackbar.dart';
import '../../../services/base_client.dart';
import '../../authentication/model/user_data_model.dart';
import '../model/product_post_res.dart';

class ProductDetailsController extends GetxController {
  //-- get Product Like Count --//
  RxnNum likeCount = RxnNum(0);
  RxBool isProductLike = RxBool(true);
  Future<void> productLikeCount({required String productId}) async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/likes/count",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment/count",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
  Future<void> productViewCount(
      {required String productId, required String productCreateTime}) async {
    log("${Constants.baseUrl}${Constants.postProduct}/$productId/views/count?since=$productCreateTime");
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/views/count?since=$productCreateTime",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/views",
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
  Rxn<ProudctPostCommentRes> productCommentListRes =
      Rxn<ProudctPostCommentRes>();
  RxList<CommentModel> productCommentList = RxList<CommentModel>();
  RxBool isProductCommentList = RxBool(true);
  Future<void> getProductComments({required String productId}) async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
  TextEditingController commentController = TextEditingController();
  Future<void> addProductComment(
      {required String productId, required String comment}) async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$productId/comment",
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {"content": comment},
      onLoading: () {
        FocusScope.of(Get.context!).unfocus();
        isProductCommentAdd.value = true;
      },
      onSuccess: (response) {
        commentController.clear();
        getProductComments(productId: productId);
        isProductCommentAdd.value = false;
      },
      onError: (e) {
        if (e.response?.data['result'] != null) {
          CustomSnackBar.showCustomErrorToast(
              message: e.response?.data['result']);
        }
        isProductCommentAdd.value = false;
      },
    );
  }

  //-- get User by User Id --//
  Rxn<UserDataModel> postUserModel = Rxn<UserDataModel>();
  RxBool isFetchUserLoading = RxBool(true);
  Future<void> getUserByUId({required String userId}) async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.user}/$userId",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {},
      onSuccess: (response) {
        Map<String, dynamic> data = response.data;
        postUserModel.value = UserDataModel.fromJson(data);
        selectUserId = postUserModel.value?.id ?? '';
        isFetchUserLoading.value = false;
      },
      onError: (p0) {
        isFetchUserLoading.value = false;
      },
    );
  }

  //--- Get User PRODUCT ---//

  RxBool isFetchUserProduct = RxBool(true);
  RxList<ProductModel> userProductList = RxList<ProductModel>();
  ProudctPostListRes? userProductPostListRes;
  String selectUserId = '';
  Future<void> fetchUserProducts({String? nextPaginateDate}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url =
          '$url?next=$nextPaginateDate&user=${postUserModel.value?.id ?? selectUserId}';
    } else {
      url = "$url?user=${postUserModel.value?.id ?? selectUserId}";
    }

    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {},
      onLoading: () {
        if (nextPaginateDate == null) {
          isFetchUserProduct.value = true;
          userProductList.clear();
        }
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        Map<String, dynamic> responseData = response.data;
        userProductPostListRes = ProudctPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          userProductList.addAll(userProductPostListRes?.data ?? []);
        } else {
          userProductList.value = userProductPostListRes?.data ?? [];
        }
        isFetchUserProduct.value = false;
      },
      onError: (p0) {
        log('${p0.url} ${Constants.token}');
        log("Product fetching failed: ${p0.response} ${p0.response?.data}");
        isFetchUserProduct.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product fetching failed');
      },
    );
  }

  //-- Rate User --//
  RxBool isRateUserLoading = RxBool(false);
  RxDouble userRate = RxDouble(3);
  Future<void> rateUser() async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.user}/$selectUserId/rate",
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {"stars": userRate.value},
      onLoading: () {
        isRateUserLoading.value = true;
      },
      onSuccess: (response) {
        isRateUserLoading.value = false;
        Get.back();
        CustomSnackBar.showCustomToast(message: 'Rate Successfully');
        getUserByUId(userId: selectUserId);
      },
      onError: (p0) {
        log('${p0.message}${p0.url} ${Constants.token}');
        isRateUserLoading.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Rate Failed');
      },
    );
  }

  //-Get Product Details --//
  RxBool isProductDetailsLoading = RxBool(true);
  Rxn<ProductModel> selectPostProductModel = Rxn<ProductModel>();
  Future<void> getSingleProductDetails(String pId) async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$pId",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
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
    AuthController authController = Get.find();

    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.user}/follow",
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {
        "follower_id": authController.userDataModel.value.id,
        "user_id": userId,
        "follow": isFollow,
      },
      onLoading: () {
        isRateUserLoading.value = true;
      },
      onSuccess: (response) {
        isRateUserLoading.value = false;

        CustomSnackBar.showCustomToast(
            message: '${!isFollow ? "UnFollow" : 'Follow'} Successfully');
        getUserByUId(userId: selectUserId);
      },
      onError: (p0) {
        log('${p0.message}${p0.url} ${Constants.token}');
        isRateUserLoading.value = false;
        isFetchUserLoading.value = true;
        CustomSnackBar.showCustomErrorToast(message: 'Follow Failed');
      },
    );
  }

  //-- dispose --//
  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}

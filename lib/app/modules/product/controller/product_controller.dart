import 'dart:developer';
import 'dart:io';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_snackbar.dart';
import '../../app_home/controller/home_controller.dart';
import '../../authentication/controller/auth_controller.dart';
import '../model/product_post_list_res.dart';

class ProductController extends GetxController {
  RxBool isShowPostProductVideo = RxBool(false);
  RxBool isProductPosting = RxBool(false);
  RxList<File> pickImageList = RxList([]);
  RxList<File> pickVideoList = RxList([]);
  RxList<Uint8List?> videoThumbnails = <Uint8List?>[].obs;
  Rxn<TimeOfDay> fromTime = Rxn<TimeOfDay>();
  Rxn<TimeOfDay> toTime = Rxn<TimeOfDay>();

  /// post product
  Rxn<CategoriesModel> selectCategory = Rxn<CategoriesModel>();
  RxString selectedBrand = RxString("");
  RxString selectedModel = RxString("");
  RxString selectedBodyType = RxString("");
  RxString selectedTransmission = RxString("");
  RxString selectedEngineType = RxString("");
  RxString selectedColor = RxString("");
  RxString selectedYear = RxString('20000');
  RxString selectedPassed = RxString('1999');
  RxInt totalProductFiled = RxInt(12);
  RxInt totalProductFiledCount = RxInt(0);
  TextEditingController estateDealTypeController = TextEditingController();
  TextEditingController estateAddressController = TextEditingController();
  TextEditingController estateTypeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController vinCode = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController room = TextEditingController();

  ///Individual Info
  RxString selectedLocation = RxString("");
  RxBool allowCall = RxBool(true);
  RxBool contactOnlyWithChat = RxBool(true);
  TextEditingController phoneNumberController = TextEditingController();

  //price
  TextEditingController priceController = TextEditingController();
  RxBool isExchange = RxBool(true);
  RxBool isCredit = RxBool(true);
  //-- On Init Method --//
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // field calculated
  calculateFilledFields() {
    int filledCount = 0;
    if (selectCategory.value != null) filledCount++;
    if (selectedBrand.value.isNotEmpty) filledCount++;
    if (selectedModel.value.isNotEmpty) filledCount++;
    if (selectedBodyType.value.isNotEmpty) filledCount++;
    if (selectedTransmission.value.isNotEmpty) filledCount++;
    if (selectedEngineType.value.isNotEmpty) filledCount++;
    if (selectedPassed.value.isNotEmpty) filledCount++;
    if (selectedYear.value.isNotEmpty) filledCount++;
    if (selectedColor.value.isNotEmpty) filledCount++;
    if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
    if (productNameController.text.trim().isNotEmpty) filledCount++;
    if (vinCode.text.trim().isNotEmpty) filledCount++;

    totalProductFiledCount.value = filledCount;
  }

  // PICK IMAGE FOR POST PRODUCT
  Future<List<File>?> pickImage(BuildContext context,
      {bool external = false}) async {
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
          maxAssets: external ? 1 : 10,
          requestType: RequestType.image,
        ));
    if (pickImage != null) {
      if (external) {
        List<File> tempFile = [];
        for (AssetEntity imagePick in pickImage) {
          File? file = await imagePick.file;
          if (file != null) {
            tempFile.add(file);
          }
          return tempFile;
        }
      } else {
        for (AssetEntity imagePick in pickImage) {
          File? file = await imagePick.file;
          if (file != null) {
            pickImageList.add(file);
          }
          update();
        }
      }
    }
    return null;
  }

  // PICK VIDEO FOR POST PRODUCT
  Future<void> pickVideo(BuildContext context) async {
    List<AssetEntity>? pickVideo = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.video,
        ));
    if (pickVideo != null) {
      for (AssetEntity videoPick in pickVideo) {
        File? file = await videoPick.file;
        if (file != null) {
          pickVideoList.add(file);
        }
        videoThumbnails.clear();
        _generateThumbnails();
        update();
      }
    }
  }

  Future<void> _generateThumbnails() async {
    for (var videoFile in pickVideoList) {
      try {
        // final thumbnailData = await VideoThumbnail.thumbnailData(
        //   video: videoFile.path,
        //   imageFormat: ImageFormat.JPEG,
        //   maxHeight: 150,
        //   quality: 75,
        // );
        // videoThumbnails.add("thumbnailData");
      } catch (e) {
        log('Error generating thumbnail: $e');
      }
    }
  }

  Future<TimeOfDay?> showUserTimePickerDialog(BuildContext context) async {
    TimeOfDay? selectTime = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    return selectTime;
  }

  //--- POST PRODUCT ---//
  Future<void> postProduct(Map<String, dynamic> body) async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.postProduct,
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: body,
      onLoading: () {},
      onSuccess: (response) {
        log(response.toString());
        isProductPosting.value = false;
        CustomSnackBar.showCustomSnackBar(
            message: 'Product posted successfully', title: 'Success');
      },
      onError: (p0) {
        log("postProduct Error: ${p0.message} --${p0.response?.statusCode} ${p0.response?.data}");
        isProductPosting.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product posting failed');
      },
    );
  }

  //--- Get All PRODUCT ---//
  RxList<ProductModel> productList = RxList<ProductModel>();
  ProudctPostListRes? productPostListRes;
  RxBool isFetchProduct = RxBool(true);
  Future<void> fetchProducts({String? nextPaginateDate}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?next=$nextPaginateDate';
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
          isFetchProduct.value = true;
          productList.clear();
        }
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        Map<String, dynamic> responseData = response.data;
        productPostListRes = ProudctPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          productList.addAll(productPostListRes?.data ?? []);
        } else {
          productList.value = productPostListRes?.data ?? [];
        }
        isFetchProduct.value = false;
      },
      onError: (p0) {
        log('${p0.url} ${Constants.token}');
        log("Product fetching failed: ${p0.response} ${p0.response?.data}");
        isFetchProduct.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product fetching failed');
      },
    );
  }

  //--- Get All PRODUCT ---//
  RefreshController homeRefreshController =
      RefreshController(initialRefresh: false);
  void onHomeRefresh() async {
    final HomeController homeController = Get.find();
    homeController.getBanner();
    await fetchProducts();
    homeRefreshController.refreshCompleted();
  }

  void onHomeLoading() async {
    if (productPostListRes?.hasMore ?? false) {
      await fetchProducts(nextPaginateDate: productList.value.last.createdAt);
    }
    homeRefreshController.loadComplete();
  }

  //--- Get User PRODUCT ---//
  RxBool isFetchMyProduct = RxBool(true);
  RxList<ProductModel> myProductList = RxList<ProductModel>();
  ProudctPostListRes? myProductPostListRes;

  Future<void> fetchMyProducts({String? nextPaginateDate}) async {
    AuthController authController = Get.find();
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url =
          '$url?next=$nextPaginateDate&user=${authController.userDataModel.value.id}';
    } else {
      url = "$url?user=${authController.userDataModel.value.id}";
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
          isFetchMyProduct.value = true;
          myProductList.clear();
        }
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        Map<String, dynamic> responseData = response.data;
        myProductPostListRes = ProudctPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          myProductList.addAll(myProductPostListRes?.data ?? []);
        } else {
          myProductList.value = myProductPostListRes?.data ?? [];
        }
        isFetchMyProduct.value = false;
      },
      onError: (p0) {
        log('${p0.url} ${Constants.token}');
        log("Product fetching failed: ${p0.response} ${p0.response?.data}");
        isFetchMyProduct.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product fetching failed');
      },
    );
  }

  //--- Get All PRODUCT ---//
  RefreshController myListingRefreshController =
      RefreshController(initialRefresh: false);
  void myListingRefresh() async {
    await fetchMyProducts();
    myListingRefreshController.refreshCompleted();
  }

  void myListingLoading() async {
    if (myProductPostListRes?.hasMore ?? false) {
      await fetchMyProducts(
          nextPaginateDate: myProductList.value.last.createdAt);
    }
    myListingRefreshController.loadComplete();
  }
  //--- Get Like PRODUCT ---//

  RxBool isFetchLikeProduct = RxBool(true);
  RxList<ProductModel> myLikeProductList = RxList<ProductModel>();
  ProudctPostListRes? myLikeProductPostListRes;

  Future<void> fetchMyLikeProducts({String? nextPaginateDate}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?liked&next=$nextPaginateDate';
    } else {
      url = "$url?liked";
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
          isFetchLikeProduct.value = true;
          myLikeProductList.clear();
        }
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        Map<String, dynamic> responseData = response.data;
        myLikeProductPostListRes = ProudctPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          myLikeProductList.addAll(myLikeProductPostListRes?.data ?? []);
        } else {
          myLikeProductList.value = myLikeProductPostListRes?.data ?? [];
        }
        isFetchLikeProduct.value = false;
      },
      onError: (p0) {
        log('${p0.url} ${Constants.token}');
        log("Product fetching failed: ${p0.response} ${p0.response?.data}");
        isFetchLikeProduct.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product fetching failed');
      },
    );
  }

  //--- Get All PRODUCT ---//
  RefreshController myLikePostRefreshController =
      RefreshController(initialRefresh: false);
  void myLikePostRefresh() async {
    await fetchMyLikeProducts();
    myLikePostRefreshController.refreshCompleted();
  }

  void myLikePostLoading() async {
    if (productPostListRes?.hasMore ?? false) {
      await fetchMyLikeProducts(
          nextPaginateDate: myLikeProductList.value.last.createdAt);
    }
    myLikePostRefreshController.loadComplete();
  }

  /// product like
  RxBool isProductLike = RxBool(false);
  RxString productLikeId = RxString('');
  Future<void> addProductLike({required String productId}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    url = '$url/$productId/likes';
    await BaseClient.safeApiCall(
      url,
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {},
      onLoading: () {
        productLikeId.value = productId;
        isProductLike.value = true;
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        isProductLike.value = false;
        CustomSnackBar.showCustomSnackBar(
            message: 'Product liked successfully', title: 'Success');
      },
      onError: (p0) {
        log("Product like failed: ${p0.response} ${p0.response?.data}");
        isProductLike.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product like failed');
      },
    );
  }
}

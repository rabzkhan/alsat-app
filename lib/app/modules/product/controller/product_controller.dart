import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:alsat/app/modules/app_home/models/car_brand_res.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/modules/product/video_edit/crop_video.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_editor/video_editor.dart';
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
  Rxn<BrandModel> selectedBrand = Rxn<BrandModel>();
  Rxn<CarModel> selectedModel = Rxn<CarModel>();
  RxList<String> selectModelCarClass = RxList([]);
  RxString selectedBodyType = RxString("");
  RxString selectedTransmission = RxString("");
  RxString selectedEngineType = RxString("");
  RxList<String> selectedColor = RxList<String>([]);
  RxString selectedYear = RxString('20000');
  RxString selectedPassed = RxString('1999');
  //-- post product count --//
  RxInt totalProductFiled = RxInt(3);
  RxInt totalProductFiledCount = RxInt(0);
  //-- Price Field--//
  RxInt productPriceFiled = RxInt(3);
  RxInt productPriceFiledCount = RxInt(2);
  //-- individual info --//
  RxInt individualInfoFiled = RxInt(6);
  RxInt individualInfoFiledCount = RxInt(2);
  //--Text Field--//
  TextEditingController estateDealTypeController = TextEditingController();
  TextEditingController estateAddressController = TextEditingController();
  TextEditingController estateTypeController = TextEditingController();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController vinCode = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ///Individual Info
  RxString selectedPhoneBrand = RxString("");
  RxBool allowCall = RxBool(true);
  RxBool contactOnlyWithChat = RxBool(true);

  RxBool checkTermsAndConditions = RxBool(false);

  //price

  RxBool isExchange = RxBool(false);
  RxBool isCredit = RxBool(false);
  RxBool isLeftAvalable = RxBool(true);
  //-- On Init Method --//
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // field calculated
  calculateFilledProductFields() {
    //-- Category check to find the total field --//
    if (selectCategory.value != null) {
      if (selectCategory.value?.name?.toLowerCase() == 'automobile') {
        totalProductFiled.value = 11;
      }
      if (selectCategory.value?.name?.toLowerCase() == 'real estate') {
        totalProductFiled.value = 9;
      }
      if (selectCategory.value?.name?.toLowerCase() == 'phone') {
        totalProductFiled.value = 4;
      }
    }
    int filledCount = 0;
    if (selectCategory.value != null) {
      if (selectCategory.value?.name?.toLowerCase() == 'automobile') {
        if (selectCategory.value != null) filledCount++;
        if (selectedBrand.value != null) filledCount++;
        if (selectedModel.value != null) filledCount++;
        if (selectedBodyType.value.isNotEmpty) filledCount++;
        if (selectedTransmission.value.isNotEmpty) filledCount++;
        if (selectedEngineType.value.isNotEmpty) filledCount++;
        if (selectedPassed.value.isNotEmpty) filledCount++;
        if (selectedYear.value.isNotEmpty) filledCount++;
        if (selectedColor.isNotEmpty) filledCount++;
        // if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        // if (productNameController.text.trim().isNotEmpty) filledCount++;
        // if (vinCode.text.trim().isNotEmpty) filledCount++;
      }
      if (selectCategory.value?.name?.toLowerCase() == 'real estate') {
        if (selectCategory.value != null) filledCount++;
        if (estateDealTypeController.text.trim().isNotEmpty) filledCount++;
        if (estateAddressController.text.trim().isNotEmpty) filledCount++;
        if (estateTypeController.text.trim().isNotEmpty) filledCount++;
        if (floor.text.trim().isNotEmpty) filledCount++;
        if (room.text.trim().isNotEmpty) filledCount++;
        filledCount++;
        // if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        // if (productNameController.text.trim().isNotEmpty) filledCount++;
      }
      if (selectCategory.value?.name?.toLowerCase() == 'phone') {
        if (selectCategory.value != null) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (selectedPhoneBrand.isNotEmpty) filledCount++;
      } else {
        if (selectCategory.value != null) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
      }
    } else {
      // if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
      if (productNameController.text.trim().isNotEmpty) filledCount++;
    }
    totalProductFiledCount.value = filledCount;
  }

  // field calculated in individual info
  calculateFilledIndividualInfoFields() {
    int filledCount = 3;
    if (Get.find<FilterController>().selectedProvince.value != "" &&
        Get.find<FilterController>().selectedCity.value != "") filledCount++;

    if (toTime.value != null) filledCount++;
    if (fromTime.value != null) filledCount++;
    individualInfoFiledCount.value = filledCount;
  }

  // PICK IMAGE FOR POST PRODUCT
  Future<List<File>?> pickImage(BuildContext context,
      {bool external = false, bool both = false}) async {
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: external ? 1 : 10,
        requestType: both ? RequestType.all : RequestType.image,
      ),
    );
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
  File? pickVideoFile;
  Future<void> pickVideo(BuildContext context) async {
    List<AssetEntity>? pickVideo = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.video,
          shouldAutoplayPreview: true,
        ));
    if (pickVideo != null) {
      for (AssetEntity videoPick in pickVideo) {
        File? file = await videoPick.file;
        if (file != null) {
          // pickVideoList.value = [file];
          pickVideoFile = file;
        }
      }

      generateThumbnails();
      update();
    }
  }

  Future<void> generateThumbnails() async {
    videoThumbnails.clear();
    for (var videoFile in pickVideoList) {
      try {
        final thumbnailData = await VideoThumbnail.thumbnailData(
          video: videoFile.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 150,
          quality: 75,
        );
        videoThumbnails.add(thumbnailData);
      } catch (e) {
        log('Error generating thumbnail: $e');
      }
    }
  }

  Future<TimeOfDay?> showUserTimePickerDialog(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    return selectedTime;
  }

  //--- POST PRODUCT ---//
  Future<bool> postProduct(Map<String, dynamic> body) async {
    // log('body: $body');
    return await BaseClient.safeApiCall(
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
        CustomSnackBar.showCustomToast(
            message: 'Product posted successfully', title: 'Success');
        return true;
      },
      onError: (p0) {
        log("postProduct Error: ${p0.message} --${p0.response?.statusCode} ${p0.response?.data}");
        isProductPosting.value = false;
        CustomSnackBar.showCustomToast(
            color: Colors.red, message: 'Product posting failed');
        return false;
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
  Future<void> addProductLike(
      {required String productId, required bool likeValue}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    url = '$url/$productId/likes';
    log('$url ${Constants.token}');
    await BaseClient.safeApiCall(
      url,
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: {"like": likeValue},
      onLoading: () {
        productLikeId.value = productId;
        isProductLike.value = true;
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        isProductLike.value = false;
        CustomSnackBar.showCustomToast(
            message: 'Product ${likeValue ? "liked" : "Unliked"} Successfully',
            title: 'Success');
      },
      onError: (p0) {
        log("Product like failed: ${p0.response} ${p0.response?.data}");
        isProductLike.value = false;
        CustomSnackBar.showCustomErrorToast(message: 'Product like failed');
      },
    );
  }

  //-- get my current location--//
  google_maps_flutter.LatLng? selectLatLon;
  google_maps_flutter.LatLng selectPosition =
      const google_maps_flutter.LatLng(0, 0);
  final Completer<google_maps_flutter.GoogleMapController> mapController =
      Completer();
  Rxn<LocationData> currentLocation = Rxn();
  RxList<geocoding.Placemark> placemarks = RxList([]);

  Future<void> getCurrentLocation() async {
    log("Call getCurrentLocation");
    Location location = Location();
    await location.getLocation().then(
      (location) {
        currentLocation.value = location;
        getLatLngToAddress(
          google_maps_flutter.LatLng(
            location.latitude ?? 0,
            location.longitude ?? 0,
          ),
        );
      },
    );

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation.value = newLoc;
      },
    );
  }

  getLatLngToAddress(google_maps_flutter.LatLng latLng) async {
    selectLatLon = latLng;
    placemarks.value = await geocoding.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);

    calculateFilledIndividualInfoFields();
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
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alsat/app/modules/app_home/models/car_brand_res.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/filter/controllers/filter_controller.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps_flutter;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_snackbar.dart';
import '../../app_home/controller/home_controller.dart';
import '../model/product_post_list_res.dart';

class ProductController extends GetxController {
  RxList<String> dBodyType = <String>["Coupe", "Sedan", "Suv", "Hatchback", "Crossover", "Van"].obs;
  RxList<String> dDriveType = <String>['RWD', 'FWD', 'AWD', '4WD'].obs;
  RxString driveType = "".obs;
  List<String> estateTypeList = [
    'Apartment',
    'Elite',
    'Half-Elite',
    'Cottage',
    'Villa',
  ];

  List<String> estateDealTypeList = [
    'Cosmetic',
    'Government',
    'Euro',
    'Designer',
    'Regular',
  ];
  RxBool isShowPostProductVideo = RxBool(false);
  RxBool isProductPosting = RxBool(false);
  RxList<File> pickImageList = RxList([]);
  RxList<File> pickVideoList = RxList([]);
  RxList<Uint8List?> videoThumbnails = <Uint8List?>[].obs;
  Rxn<TimeOfDay> fromTime = Rxn<TimeOfDay>(TimeOfDay(hour: 0, minute: 0));
  Rxn<TimeOfDay> toTime = Rxn<TimeOfDay>(TimeOfDay(hour: 23, minute: 59));

  /// post product
  Rxn<CategoriesModel> selectCategory = Rxn<CategoriesModel>();
  Rxn<SubCategories> selectSubCategory = Rxn<SubCategories>();
  Rxn<BrandModel> selectedBrand = Rxn<BrandModel>();
  Rxn<CarModel> selectedModel = Rxn<CarModel>();
  RxList<String> selectModelCarClass = RxList([]);
  RxString selectedModelClass = RxString("");
  RxString selectedBodyType = RxString("");
  RxString selectedTransmission = RxString("");
  RxString selectedEngineType = RxString("");
  RxList<String> selectedColor = RxList<String>([]);
  RxString selectedYear = RxString(DateTime.now().year.toString());
  //RxString selectedPassed = RxString('7000');
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
  RxnString estateDealType = RxnString();
  RxString selectRoom = RxString('1');
  RxString selectFloor = RxString('1');
  TextEditingController estateAddressController = TextEditingController();
  RxnString estateType = RxnString();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController vinCode = TextEditingController();
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
    bool isCar = selectCategory.value?.filter?.toLowerCase() == 'car' ||
        (selectSubCategory.value?.filter ?? "").toLowerCase() == "car";
    bool isRealEstate = (selectCategory.value?.filter ?? '').toLowerCase().contains('real_estate') ||
        (selectSubCategory.value?.filter ?? '').toLowerCase().contains('real_estate');
    bool isPhone = selectCategory.value?.filter?.toLowerCase() == 'phone' ||
        selectSubCategory.value?.filter?.toLowerCase() == 'phone';

    //-- Category check to find the total field --//
    totalProductFiledCount.value = 0;
    totalProductFiled.value = 0;
    if (selectCategory.value != null) {
      if (isCar) {
        totalProductFiled.value = 11;
      } else if (isRealEstate) {
        totalProductFiled.value = 9;
      } else if (isPhone) {
        totalProductFiled.value = 5;
      } else {
        totalProductFiled.value = 4;
      }
    }
    // log('isCar: $isCar isRealEstate: $isRealEstate isPhone: $isPhone: $totalProductFiled');
    int filledCount = 0;
    if (selectCategory.value != null) {
      if (isCar) {
        if (selectCategory.value != null) filledCount++;
        if (selectSubCategory.value != null) filledCount++;
        if (selectedBrand.value != null) filledCount++;
        if (selectedModel.value != null) filledCount++;
        if (selectedBodyType.value.isNotEmpty) filledCount++;
        if (selectedTransmission.value.isNotEmpty) filledCount++;
        if (selectedEngineType.value.isNotEmpty) filledCount++;
        if (selectedYear.value.isNotEmpty) filledCount++;
        if (selectedColor.isNotEmpty) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
        // if (vinCode.text.trim().isNotEmpty) filledCount++;
      } else if (isRealEstate) {
        if (selectCategory.value != null) filledCount++;
        if (selectSubCategory.value != null) filledCount++;
        if ((estateDealType.value ?? "").isNotEmpty) filledCount++;
        if (estateAddressController.text.trim().isNotEmpty) filledCount++;
        if ((estateType.value ?? '').isNotEmpty) filledCount++;
        if (selectFloor.value.isNotEmpty) filledCount++;
        if (selectRoom.value.isNotEmpty) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
      } else if (isPhone) {
        if (selectCategory.value != null) filledCount++;
        if (selectSubCategory.value != null) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (selectedPhoneBrand.isNotEmpty) filledCount++;
      } else {
        if (selectCategory.value != null) filledCount++;
        if (selectSubCategory.value != null) filledCount++;
        if (productDescriptionController.text.trim().isNotEmpty) filledCount++;
        if (productNameController.text.trim().isNotEmpty) filledCount++;
      }
    } else {
      totalProductFiledCount.value = 0;
      totalProductFiled.value = 1;
    }
    totalProductFiledCount.value = filledCount;
  }

  // field calculated in individual info
  calculateFilledIndividualInfoFields() {
    int filledCount = 3;
    if (Get.find<FilterController>().selectedProvince.value != "" &&
        Get.find<FilterController>().selectedCity.value != "") {
      filledCount++;
    }

    if (toTime.value != null) filledCount++;
    if (fromTime.value != null) filledCount++;
    individualInfoFiledCount.value = filledCount;
  }

  // PICK IMAGE FOR POST PRODUCT
  Future<List<File>?> pickImage(BuildContext context,
      {bool external = false, bool both = false, int? pickItems}) async {
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: pickItems ?? (external ? 1 : 10),
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
        }
        return tempFile;
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
  Future<File?> pickVideo(BuildContext context, {bool external = false}) async {
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
      if (external) {
        return pickVideoFile;
      } else {
        generateThumbnails();
        update();
      }
    }
    return null;
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
    final localLanguage = AppLocalizations.of(Get.context!)!;
    HomeController homeController = Get.find<HomeController>();
    return BaseClient().safeApiCall(
      Constants.baseUrl + Constants.postProduct,
      DioRequestType.post,
      data: body,
      onLoading: () {
        isProductPosting.value = true;
      },
      onSuccess: (response) async {
        isProductPosting.value = false;
        CustomSnackBar.showCustomToast(
          message: localLanguage.product_posted_successfully,
        );
        Get.back();
        resetForm();
        await homeController.getUserPostCategories();
        await homeController.fetchMyProducts();
        return true;
      },
      onError: (p0) {
        isProductPosting.value = false;
        log('Product Post Error ${p0.statusCode}');
        CustomSnackBar.showCustomToast(color: Colors.red, message: p0.message);
        return false;
      },
    );
  }

  //--- Get All PRODUCT ---//
  RxList<ProductModel> productList = RxList<ProductModel>();
  ProductPostListRes? productPostListRes;
  RxBool isFetchProduct = RxBool(true);
  Future<void> fetchProducts({String? nextPaginateDate}) async {
    // final localLanguage = AppLocalizations.of(Get.context!)!;
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?next=$nextPaginateDate';
    }
    log('All Product:-${url}');
    await BaseClient().safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        // 'Authorization': Constants.token,
      },
      data: {},
      onLoading: () {
        if (nextPaginateDate == null) {
          isFetchProduct.value = true;
          productList.clear();
        }
      },
      onSuccess: (response) {
        Map<String, dynamic> responseData = response.data;
        productPostListRes = ProductPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          productList.addAll(productPostListRes?.data ?? []);
        } else {
          productList.value = productPostListRes?.data ?? [];
        }
        isFetchProduct.value = false;
      },
      onError: (p0) {
        log('All Product Error: ${p0.statusCode}: ${p0.url}');
        isFetchProduct.value = false;
        // CustomSnackBar.showCustomErrorToast(message: localLanguage.product_fetching_failed);
      },
    );
  }

  //--- Get All PRODUCT ---//
  RefreshController homeRefreshController = RefreshController(initialRefresh: false);
  void onHomeRefresh() async {
    final HomeController homeController = Get.find();
    homeController.getBanner();
    homeController.userOwnStory();
    await fetchProducts();
    homeRefreshController.refreshCompleted();
  }

  void onHomeLoading() async {
    if (productPostListRes?.hasMore ?? false) {
      await fetchProducts(nextPaginateDate: productList.last.createdAt);
    }
    homeRefreshController.loadComplete();
  }

  //--- Get Like PRODUCT ---//

  RxBool isFetchLikeProduct = RxBool(true);
  RxList<ProductModel> myLikeProductList = RxList<ProductModel>();
  ProductPostListRes? myLikeProductPostListRes;

  Future<void> fetchMyLikeProducts({String? nextPaginateDate}) async {
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?liked&next=$nextPaginateDate';
    } else {
      url = "$url?liked";
    }
    final localLanguage = AppLocalizations.of(Get.context!)!;
    await BaseClient().safeApiCall(
      url,
      DioRequestType.get,
      data: {},
      onLoading: () {
        if (nextPaginateDate == null) {
          isFetchLikeProduct.value = true;
          myLikeProductList.clear();
        }
      },
      onSuccess: (response) {
        log('Like Url${response.requestOptions.baseUrl} ${response.requestOptions.path} ${response.requestOptions.data}');
        Map<String, dynamic> responseData = response.data;
        myLikeProductPostListRes = ProductPostListRes.fromJson(responseData);
        if (nextPaginateDate != null) {
          myLikeProductList.addAll(myLikeProductPostListRes?.data ?? []);
        } else {
          myLikeProductList.value = myLikeProductPostListRes?.data ?? [];
        }
        isFetchLikeProduct.value = false;
      },
      onError: (p0) {
        isFetchLikeProduct.value = false;
        CustomSnackBar.showCustomErrorToast(message: localLanguage.product_fetching_failed);
      },
    );
  }

  //--- Get All PRODUCT ---//
  RefreshController myLikePostRefreshController = RefreshController(initialRefresh: false);
  void myLikePostRefresh() async {
    await fetchMyLikeProducts();
    myLikePostRefreshController.refreshCompleted();
  }

  void myLikePostLoading() async {
    if (productPostListRes?.hasMore ?? false) {
      await fetchMyLikeProducts(nextPaginateDate: myLikeProductList.last.createdAt);
    }
    myLikePostRefreshController.loadComplete();
  }

  /// product like
  RxBool isProductLike = RxBool(false);
  RxString productLikeId = RxString('');
  Future<void> addProductLike({required String productId, required bool likeValue}) async {
    final localLanguage = AppLocalizations.of(Get.context!)!;
    String url = Constants.baseUrl + Constants.postProduct;
    url = '$url/$productId/likes';
    await BaseClient().safeApiCall(
      url,
      DioRequestType.post,
      data: {"like": likeValue},
      onLoading: () {
        productLikeId.value = productId;
        isProductLike.value = true;
      },
      onSuccess: (response) {
        log('${response.requestOptions.baseUrl} ${response.requestOptions.path}');
        isProductLike.value = false;
        // CustomSnackBar.showCustomToast(
        //     message:
        //         '${localLanguage.product} ${likeValue ? localLanguage.liked : localLanguage.unliked} ${localLanguage.successfully}',
        //     title: localLanguage.successfully);
        fetchMyLikeProducts();
      },
      onError: (p0) {
        log("Product like failed: ${p0.response} ${p0.response?.data}");
        isProductLike.value = false;
        CustomSnackBar.showCustomToast(message: localLanguage.product_like_failed);
      },
    );
  }

  //-- get my current location--//
  google_maps_flutter.LatLng? selectLatLon;
  google_maps_flutter.LatLng selectPosition = const google_maps_flutter.LatLng(0, 0);
  final Completer<google_maps_flutter.GoogleMapController> mapController = Completer();
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
    placemarks.value = await geocoding.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    calculateFilledIndividualInfoFields();
  }

  //-Get Product Details --//
  RxBool isProductDetailsLoading = RxBool(true);
  Rxn<ProductModel> selectPostProductModel = Rxn<ProductModel>();
  Rxn<ProductModel> selectExtraPostProductModel = Rxn<ProductModel>();
  Future<void> getSingleProductDetails(String pId, {bool external = false}) async {
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$pId",
      DioRequestType.get,
      onLoading: () {
        isProductDetailsLoading.value = true;
        if (!external) {
          selectPostProductModel.value = null;
        }
      },
      onSuccess: (response) {
        Map<String, dynamic> data = response.data;
        if (external) {
          selectExtraPostProductModel.value = ProductModel.fromJson(data);
        } else {
          selectPostProductModel.value = ProductModel.fromJson(data);
        }
        isProductDetailsLoading.value = false;
        return selectPostProductModel.value;
      },
      onError: (p0) {
        log('Single product fetching failed: ${p0.message}');
        isProductDetailsLoading.value = false;
        return null;
      },
    );
  }

  final postKey = GlobalKey<FormBuilderState>();
  resetForm() {
    isProductPosting.value = false;
    // postKey.currentState?.reset();
    estateDealType.value = null;
    priceController.text = '';
    estateAddressController.clear();
    estateType.value = null;
    selectedPhoneBrand.value = '';
    productNameController.clear();
    productDescriptionController.clear();
    vinCode.clear();
    priceController.clear();
    pickImageList.clear();
    selectCategory.value = null;
    selectSubCategory.value = null;
    selectedBrand.value = null;
    selectedModel.value = null;
    selectedBodyType.value = '';
    selectedTransmission.value = '';
    selectedEngineType.value = '';
    selectedColor.value = [];
    fromTime.value = null;
    toTime.value = null;
  }

  //--- add Image Video In  Post---//
  RxList<File> pickUpdateImageList = RxList([]);
  RxList<File> pickUpdateVideoList = RxList([]);
  RxBool isUploadingMediaImageInPost = false.obs;
  RxBool isUploadingMediaVideoInPost = false.obs;
  Future<void> uploadMediaInPost({required String postId, bool isVideoUpload = false}) async {
    final HomeController homeController = Get.find();
    List<Map<String, dynamic>> mediaData = [];
    if (pickUpdateImageList.isNotEmpty && !isVideoUpload) {
      for (var image in pickUpdateImageList) {
        final imageMap = await imageToBase64(image.path);
        mediaData.add(imageMap);
      }
    }
    if (pickUpdateVideoList.isNotEmpty && isVideoUpload) {
      for (var video in pickUpdateVideoList) {
        final videoMap = await videoToBase64(video.path);
        mediaData.add(videoMap);
      }
    }
    return BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$postId/media/add-many",
      DioRequestType.put,
      data: mediaData,
      onLoading: () {
        if (isVideoUpload) {
          isUploadingMediaVideoInPost.value = true;
        } else {
          isUploadingMediaImageInPost.value = true;
        }
      },
      onSuccess: (response) async {
        await homeController.fetchMyProducts();
        if (isVideoUpload) {
          isUploadingMediaVideoInPost.value = false;
          pickUpdateVideoList.clear();
          CustomSnackBar.showCustomToast(
            message: 'Video uploaded successfully',
          );
        } else {
          isUploadingMediaImageInPost.value = false;
          pickUpdateImageList.clear();
          CustomSnackBar.showCustomToast(
            message: 'Image uploaded successfully',
          );
        }
      },
      onError: (error) {
        log('Failed to upload media: ${error.message} $postId');
        CustomSnackBar.showCustomToast(
          message: error.message ?? 'Failed to update post',
          color: Colors.red,
        );
        if (isVideoUpload) {
          isUploadingMediaVideoInPost.value = false;
        } else {
          isUploadingMediaImageInPost.value = false;
        }
      },
    );
  }

  //--- delete Media In  Post---//
  RxBool isDeletingMediaInPost = false.obs;
  Future<void> deleteMediaInPost({required String pId, required String mediaId}) async {
    final HomeController homeController = Get.find();
    return BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$pId/media/delete-many",
      DioRequestType.put,
      data: [mediaId],
      onLoading: () {
        isDeletingMediaInPost.value = true;
      },
      onSuccess: (response) async {
        await homeController.fetchMyProducts();
        isDeletingMediaInPost.value = false;
        log('Media deleted successfully');
      },
      onError: (error) {
        log('Error deleting media: $error');
        isDeletingMediaInPost.value = false;
      },
    );
  }

  //-- update post information ---//
  final postUpdateFromKey = GlobalKey<FormBuilderState>();
  RxBool isUpdatingPost = false.obs;
  Future<void> updatePost({
    required String postId,
    required Map<String, dynamic> data,
  }) async {
    Logger().d(data.toString());
    final HomeController homeController = Get.find();
    isUpdatingPost.value = true;
    await BaseClient().safeApiCall(
      "${Constants.baseUrl}${Constants.postProduct}/$postId",
      DioRequestType.put,
      data: data,
      onLoading: () {},
      onSuccess: (response) async {
        await homeController.fetchMyProducts();
        isUpdatingPost.value = false;
        CustomSnackBar.showCustomToast(
          message: 'Post updated successfully',
        );
      },
      onError: (error) {
        log('Error updating post: $error');
        isUpdatingPost.value = false;
        CustomSnackBar.showCustomToast(
          message: 'Failed to update post',
          color: Colors.red,
        );
      },
    );
  }
}

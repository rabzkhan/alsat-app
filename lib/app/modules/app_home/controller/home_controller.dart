import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../utils/constants.dart';
import '../../../common/const/image_path.dart';
import '../../../services/base_client.dart';
import '../../authentication/model/all_user_model.dart';
import '../../authentication/model/user_data_model.dart';
import '../../filter/controllers/filter_controller.dart';
import '../../product/model/product_post_list_res.dart';
import '../../story/model/story_res.dart';
import '../models/banner_res.dart';
import '../models/car_brand_res.dart';

class HomeController extends GetxController {
  RxBool isShowSearch = false.obs;
  RxBool showPremium = false.obs;
  //home page variable
  RxInt profileTabCurrentPage = RxInt(0);
  RxInt homeBottomIndex = RxInt(0);
  RxInt categoryExpandedIndex = RxInt(0);
  RxBool isCategoryLoading = false.obs;

  List<Map<String, dynamic>> bottomBarItems(AppLocalizations localLanguage) => [
        {
          "icon": homeIcon,
          "name": localLanguage.home,
        },
        {
          "icon": searchIcon,
          "name": localLanguage.search,
        },
        {
          "icon": addPost,
          "name": localLanguage.addPost,
        },
        {
          "icon": chatIcon,
          "name": localLanguage.chat,
        },
        {
          "icon": profileIcon,
          "name": localLanguage.profile,
        },
      ];
  PageController homePageController = PageController();

  RxList<CategoriesModel> categories = <CategoriesModel>[].obs;
  //-- init method --//
  @override
  Future<void> onInit() async {
    getCategories();
    getBanner();
    fetchCarBrand();
    getUserPostCategories();
    userOwnStory();
    super.onInit();
  }

//-- get categories --//
  getCategories() async {
    log('CategoryCall: ${Constants.baseUrl + Constants.categories}');
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.categories,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isCategoryLoading.value = true;
      },
      onSuccess: (response) async {
        Logger().d(response.data.toString());
        List<dynamic> data = response.data;
        categories.value = data.map((json) => CategoriesModel.fromJson(json)).toList();

        isCategoryLoading.value = false;
      },
      onError: (error) {
        log('CategoryError: ${error.message}');
        Logger().d("$error <- error");
        isCategoryLoading.value = false;
      },
    );
  }

//-- get categories --//
  RxList<CategoriesModel> userPostCategories = <CategoriesModel>[].obs;
  RxBool isUserPostCategoryLoading = false.obs;
  getUserPostCategories() async {
    AuthController authController = Get.find();
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}/posts/categories?user_id=${authController.userDataModel.value.id}",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isUserPostCategoryLoading.value = true;
      },
      onSuccess: (response) async {
        Logger().d(response.data.toString());
        List<dynamic> data = response.data;
        userPostCategories.value = data.map((json) => CategoriesModel.fromJson(json)).toList();
        log('userPostCategories: ${userPostCategories.length}');
        myListingSelectCategory.value = userPostCategories.first;
        fetchMyProducts();
        isUserPostCategoryLoading.value = false;
      },
      onError: (error) {
        isUserPostCategoryLoading.value = false;
      },
    );
  }

  //-- Get Home Banner --//
  RxList<BannerModel> mainBanner = <BannerModel>[].obs;
  RxList<BannerModel> otherBanner = <BannerModel>[].obs;
  RxBool isBannerLoading = false.obs;
  getBanner() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.banners,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isBannerLoading.value = true;
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        BannerRes bannerRes = BannerRes.fromJson(data);
        for (var element in bannerRes.data!) {
          if (element.main == true) {
            mainBanner.add(element);
          } else {
            otherBanner.add(element);
          }
        }
        isBannerLoading.value = false;
      },
      onError: (error) {
        log('CategoryError: ${error.message}');
        Logger().d("$error <- error");
        isBannerLoading.value = false;
      },
    );
  }

  //-- Get Brand --//
  RxList<BrandModel> brandList = <BrandModel>[].obs;
  RxBool isBrandLoading = true.obs;
  fetchCarBrand() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.carBrandEndPoint,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isBrandLoading.value = true;
        brandList.clear();
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        CarBrandRes carBrandRes = CarBrandRes.fromJson(data);
        brandList.value = carBrandRes.data ?? [];
        log("Brand List: ${brandList.length}");
        isBrandLoading.value = false;
      },
      onError: (error) {
        isBrandLoading.value = false;
      },
    );
  }

  //-- Get All Primisum User--//
  RxnString followersValue = RxnString();
  RxnString registrationValue = RxnString();
  RxBool isActiveUser = false.obs;
  RxBool buyerProtection = false.obs;
  Rxn<CategoriesModel> category = Rxn<CategoriesModel>();
  AllUserInformationRes allUserInformationRes = AllUserInformationRes();
  RxList<UserDataModel> premiumUserList = <UserDataModel>[].obs;
  RxList<UserDataModel> filterUserList = <UserDataModel>[].obs;
  RxBool isPremiumLoading = true.obs;
  RxBool isFilterLoading = true.obs;
  RxString searchText = RxString('');
  TextEditingController searchController = TextEditingController();
  Future<void> fetchPremiumUser({String? nextPaginateDate, bool isFilter = false}) async {
    FilterController filterController = Get.find<FilterController>();

    String url = '${Constants.baseUrl}/users?plan=premium&limit=10';
    if (nextPaginateDate != null) {
      url = "$url&next=$nextPaginateDate";
    }
    Map<String, dynamic> data = isFilter
        ? {
            "category": category.value?.name,
            "online": isActiveUser.value,
            "buyer_protection": buyerProtection.value,
            "location":
                filterController.getSelectedLocationData().isEmpty ? null : filterController.getSelectedLocationData(),
            "sorting": {
              "follower": followersValue.value == 'Max To Min' ? -1 : 1,
              "registration": registrationValue.value == 'Old To New' ? 1 : -1,
            }
          }
        : {"category": category.value?.name};
    if (searchText.value.isNotEmpty) {
      data.clear();
      data['search'] = searchText.value;
    }
    log('Premium User: Date: $data-- $url');
    data.removeWhere((key, value) => value == null);
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: data,
      onLoading: () {
        if (nextPaginateDate == null && !isFilter) {
          isPremiumLoading.value = true;
          isFilterLoading.value = true;
          premiumUserList.clear();
        }
        if (isFilter && nextPaginateDate == null) {
          isFilterLoading.value = true;
          filterUserList.clear();
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        allUserInformationRes = AllUserInformationRes.fromJson(data);
        if (nextPaginateDate != null) {
          if (isFilter) {
            filterUserList.addAll(allUserInformationRes.data?.users ?? []);
          } else {
            filterUserList.addAll(allUserInformationRes.data?.users ?? []);
            premiumUserList.addAll(allUserInformationRes.data?.users ?? []);
          }
        } else {
          if (isFilter) {
            filterUserList.value = allUserInformationRes.data?.users ?? [];
          } else {
            filterUserList.value = allUserInformationRes.data?.users ?? [];
            premiumUserList.value = allUserInformationRes.data?.users ?? [];
          }
        }
        isPremiumLoading.value = false;
        isFilterLoading.value = false;
        log("fetchPremiumUser List: ${premiumUserList.value.length} ${filterUserList.length} ${response.requestOptions.data}");
        return;
      },
      onError: (error) {
        log('premiumRefreshController:${Constants.baseUrl}${Constants.user}?limit=20 ${error.message}  ${error.response?.requestOptions.data}');
        isPremiumLoading.value = false;
        isFilterLoading.value = false;
        Logger().d("$error <- error");
        return;
      },
    );
  }

  RefreshController premiumRefreshController = RefreshController(initialRefresh: true);
  void onPremiumRefresh() async {
    premiumUserList.clear();
    fetchPremiumUser();
    premiumRefreshController.refreshCompleted();
  }

  void onPremiumLoading() async {
    await fetchPremiumUser(nextPaginateDate: premiumUserList.last.createdAt);
    premiumRefreshController.loadComplete();
  }

  ///===========================================================================================================
  RefreshController userFilterRefreshController = RefreshController();
  void onUserFilterRefresh() async {
    filterUserList.clear();
    fetchPremiumUser(isFilter: true);
    userFilterRefreshController.refreshCompleted();
  }

  void onUserFilterLoading() async {
    await fetchPremiumUser(nextPaginateDate: filterUserList.last.createdAt, isFilter: true);
    userFilterRefreshController.loadComplete();
  }

  //========================================Story========================================================///
  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxBool isStoryLoading = false.obs;
  fetchAppStores() async {
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.stories}",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isStoryLoading.value = true;
      },
      onSuccess: (response) async {
        List<dynamic> data = response.data;
        List<StoryModel> story = data.map((json) => StoryModel.fromJson(json)).toList();
        storyList.addAll(story);
        isStoryLoading.value = false;
        storyList.refresh();
        log('fetchUserStory: ${storyList.length}');
      },
      onError: (error) {
        log('fetchUserStoryError: ${error.message}');
        isStoryLoading.value = false;
        storyList.refresh();
      },
    );
  }

  userOwnStory() async {
    AuthController authController = Get.find();
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.stories}?user_id=${authController.userDataModel.value.id}",
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        storyList.clear();
      },
      onSuccess: (response) async {
        List<dynamic> data = response.data;
        storyList.value = data.map((json) => StoryModel.fromJson(json)).toList();
        fetchAppStores();
      },
      onError: (error) {
        fetchAppStores();
      },
    );
  }

  //========================================Story Image Picker========================================================///
  List<File> pickStoryImageList = [];
  List<File> pickStoryVideoList = [];

  Future<void> storyAssetPicker(
    BuildContext context,
  ) async {
    pickStoryImageList = [];
    pickStoryVideoList = [];
    List<AssetEntity>? pickImage = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.common,
      ),
    );
    if (pickImage != null) {
      for (AssetEntity imagePick in pickImage) {
        File? file = await imagePick.file;
        if (file != null) {
          if (imagePick.type == AssetType.video) {
            pickStoryVideoList.add(file);
          } else {
            pickStoryImageList.add(file);
          }
        }
        update();
      }
    }
    return;
  }

  void openEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          pickStoryImageList.first,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              String base64String = base64Encode(bytes);
              int size = bytes.length;
              var hash = md5.convert(bytes).toString();
              Map<String, dynamic> media = {
                "media": {
                  "name": base64String,
                  "type": "image",
                  "size": size,
                  "hash": hash,
                  "content_type": "image/jpg"
                }
              };
              postStory(media);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  //-- Post Story --//
  RxBool isStoryPostLoading = false.obs;
  Future<void> postStory(Map<String, dynamic> data) async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.stories,
      DioRequestType.post,
      headers: {
        // 'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: data,
      onLoading: () {
        isStoryPostLoading.value = true;
      },
      onSuccess: (response) async {
        isStoryPostLoading.value = false;
        userOwnStory();
        pickStoryImageList.clear();
        update();
      },
      onError: (error) {
        isStoryPostLoading.value = false;
        log('postStoryError: ${error.message}');
        Logger().d("$error <- error");
      },
    );
  }

  //--- Get User PRODUCT ---//
  RxBool isFetchMyProduct = RxBool(true);
  RxList<ProductModel> myProductList = RxList<ProductModel>();
  ProductPostListRes? myProductPostListRes;

  Future<void> fetchMyProducts({String? nextPaginateDate}) async {
    AuthController authController = Get.find();
    String url = Constants.baseUrl + Constants.postProduct;
    if (nextPaginateDate != null) {
      url = '$url?next=$nextPaginateDate&user=${authController.userDataModel.value.id}';
    } else {
      url = "$url?user=${authController.userDataModel.value.id}";
    }
    Map<String, dynamic> data =
        myListingSelectCategory.value != null ? {"category_id": myListingSelectCategory.value!.sId ?? ""} : {};
    log('PostMy $url  ${data.toString()} ${myListingSelectCategory.value?.name}');
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: data,
      onLoading: () {
        if (nextPaginateDate == null) {
          isFetchMyProduct.value = true;
          myProductList.value = [];
        }
      },
      onSuccess: (response) {
        Map<String, dynamic> responseData = response.data;
        myProductPostListRes = ProductPostListRes.fromJson(responseData);
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

  //my listing
  Rxn<CategoriesModel> myListingSelectCategory = Rxn<CategoriesModel>();

  //--- Get All PRODUCT ---//
  RefreshController myListingRefreshController = RefreshController(initialRefresh: false);
  void myListingRefresh() async {
    await fetchMyProducts();
    myListingRefreshController.refreshCompleted();
  }

  void myListingLoading() async {
    if (myProductPostListRes?.hasMore ?? false) {
      await fetchMyProducts(nextPaginateDate: myProductList.value.last.createdAt);
    }
    myListingRefreshController.loadComplete();
  }
}

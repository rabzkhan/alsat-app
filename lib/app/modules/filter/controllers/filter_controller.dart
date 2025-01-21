import 'dart:developer' as log;
import 'dart:math';
import 'package:alsat/app/modules/filter/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';
import '../../app_home/models/car_brand_res.dart';
import '../../app_home/models/category_model.dart';
import '../../product/controller/product_controller.dart';
import '../../product/model/product_post_list_res.dart';
import '../models/location_model.dart';
import '../views/filter_results_view.dart';

class FilterController extends GetxController {
  RxList<String> dummyImage = <String>[
    "https://imgd.aeplcdn.com/664x374/n/cw/ec/110233/camry-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
    "https://imgd.aeplcdn.com/1200x900/cw/ec/37333/Toyota-Corolla-Altis-Exterior-142776.jpg?wm=0",
    "https://www.team-bhp.com/sites/default/files/pictures2021/0%20Initial.JPG",
    "https://cdn.motor1.com/images/mgl/bgg7xl/s1/2022-bmw-m3-touring.jpg",
    "https://imgd.aeplcdn.com/664x374/n/cw/ec/178535/c-class-exterior-right-front-three-quarter.jpeg?isig=0&q=80",
    "https://stimg.cardekho.com/images/carexteriorimages/930x620/Tesla/Model-X/5253/1611841733029/front-left-side-47.jpg",
    "https://s3-prod.autonews.com/s3fs-public/CYBERTRUCK-MAIN_i_5.jpg",
    "https://cdn.motor1.com/images/mgl/WRMx1/s3/mercedes-amg-g-class-with-v12-engine-from-brabus.jpg"
  ].obs;

  String getRandomImageUrl() {
    final random = Random();
    int index = random.nextInt(dummyImage.length);
    return dummyImage[index];
  }

  RxBool isFilterLoading = false.obs;

  Rxn<CategoriesModel> category = Rxn<CategoriesModel>();
  RxString accountType = "".obs;

  RxString location = "Not Chosen Yet".obs;
  RxList<BrandModel> brand = RxList<BrandModel>();
  RxList<Map<String, dynamic>> brandAndSelectedModel =
      RxList<Map<String, dynamic>>();
  RxString bodyType = "Not Chosen Yet".obs;
  RxString driveType = "Not Chosen Yet".obs;
  RxString engineType = "Not Chosen Yet".obs;
  RxString transmission = "Not Chosen Yet".obs;
  RxList<String> color = <String>[].obs;
  RxList<String> selectMobileBrand = <String>[].obs;
  RxList<String> estateTtype = <String>[].obs;
  RxString sortValue = RxString('Default');
  RxBool sortDonwnToUp = RxBool(true);

  // Real state variables

  RxList<String> dbodyType =
      <String>["Coupe", "Sedan", "Suv", "Hatchback", "Crossover", "Van"].obs;
  RxList<String> ddriveType = <String>['RWD', 'FWD', 'AWD', '4WD'].obs;
  RxList<String> dengineType = <String>["1.0", "1.3", "1.5", "1.7", "2.0"].obs;
  RxList<String> dtransmission = <String>["Manual", "Auto", "Tiptronic"].obs;
  RxList<String> estateTtypeList = <String>["house"].obs;
  RxList<Map<String, Color>> dcolor = RxList<Map<String, Color>>([
    {"Red": Colors.red},
    {"Black": Colors.black},
    {"Silver": Colors.grey}, // Usually, Silver is a shade of grey
    {"Blue": Colors.blue},
    {"White": Colors.white},
    {"Yellow": Colors.yellow},
    {"Magenta": const Color(0xFFFF00FF)},
    {"Pink": Colors.pink},
    {"Brown": Colors.brown},
    {"Green": Colors.green},
    {"Cyan": Colors.cyan},
    {"Wheat": const Color(0xFFF5DEB3)},
    {"Orange": Colors.orange},
    {"Purple": Colors.purple},
    {"Teal": Colors.teal},
    {"Indigo": Colors.indigo},
  ]);

  RxList<String> mobileBrand = <String>[
    'Apple',
    'Samsung',
    'Huawei',
    'Xiaomi',
    'Oppo',
    'Vivo',
    'OnePlus',
    'Realme',
    'Google Pixel',
    'Motorola',
    'Sony',
    'LG',
    'Nokia',
    'Asus',
    'Lenovo',
    'HTC',
    'Honor',
    'ZTE',
    'Alcatel',
    'Micromax',
    'Infinix',
    'Tecno',
    'Panasonic',
    'Lava',
    'Karbonn',
    'Meizu',
    'Sharp',
    'TCL',
    'BlackBerry',
    'Fairphone',
    'Essential Phone',
    'Razer Phone',
    'Coolpad'
  ].obs;

  Rx<TextEditingController> priceFrom = TextEditingController(text: "0").obs;
  Rx<TextEditingController> priceTo = TextEditingController(text: "300000").obs;

  RxInt yearFrom = 1995.obs;
  RxInt yearTo = 2020.obs;

  RxInt mileageFrom = 5000.obs;
  RxInt mileageTo = 100000.obs;

  RxBool credit = false.obs;
  RxBool exchange = false.obs;
  RxBool hasVinCode = false.obs;

  Rx<ItemModel> itemModel = ItemModel().obs;

  //============ for location =================== //

  // To track selected provinces
  RxSet<String> selectedProvinces = <String>{}.obs;
  // To track selected cities for each province
  RxMap<String, List<String>> selectedCities = <String, List<String>>{}.obs;

// RxString for selected province
  RxString selectedProvince = "".obs;

// RxString for selected city
  RxString selectedCity = "".obs;

// Toggle province selection with support for single or multiple selection
  void toggleProvince(String provinceName, bool allowMultipleSelection) {
    if (!allowMultipleSelection) {
      // Single selection: toggle the selected province
      if (selectedProvince.value == provinceName) {
        // If already selected, deselect it
        selectedProvince.value = "";
        selectedCity.value = "";
      } else {
        log.log("selectedProvince.value ${selectedProvince.value}");
        // If not selected, clear others and select the new one
        selectedProvince.value = provinceName;
        selectedCity.value = "";
      }
      Get.find<ProductController>().calculateFilledIndividualInfoFields();
    } else {
      // Multiple selection: toggle the province
      if (selectedProvinces.contains(provinceName)) {
        selectedProvinces.remove(provinceName);
        selectedCities.remove(provinceName);
      } else {
        selectedProvinces.add(provinceName);
        selectedCities[provinceName] = [];
      }
    }
  }

// Toggle city selection with single or multiple selection
  void toggleCity(
      String provinceName, String cityName, bool allowMultipleSelection) {
    if (!selectedProvinces.contains(provinceName) &&
        selectedProvince.value != provinceName)
      return; // Province must be selected first
    if (!allowMultipleSelection) {
      // Single selection: update the selected city
      if (selectedCity.value == cityName) {
        selectedCity.value = ""; // Deselect if already selected
      } else {
        selectedCity.value = cityName; // Select new city
      }
      Get.find<ProductController>().calculateFilledIndividualInfoFields();
    } else {
      // Multiple selection: toggle the city
      final cities = selectedCities[provinceName] ?? [];
      if (cities.contains(cityName)) {
        cities.remove(cityName);
      } else {
        cities.add(cityName);
      }
      selectedCities[provinceName] = cities; // Update the list
    }
  }

// Check if a province is selected
  bool isProvinceSelected(String provinceName) {
    if (selectedProvince.value.isNotEmpty) {
      return selectedProvince.value == provinceName;
    }
    return selectedProvinces.contains(provinceName);
  }

// Check if a city is selected under a province
  bool isCitySelected(String provinceName, String cityName) {
    if (selectedProvince.value == provinceName) {
      return selectedCity.value == cityName;
    }
    return selectedCities[provinceName]?.contains(cityName) ?? false;
  }

// Generate the final data structure
  List<Map<String, dynamic>> getSelectedLocationData() {
    if (selectedProvince.value.isNotEmpty) {
      return [
        {
          "province": selectedProvince.value,
          if (selectedCity.value.isNotEmpty) "city": selectedCity.value,
        }
      ];
    }
    return selectedProvinces.map((province) {
      final cities = selectedCities[province];
      return {
        "province": province,
        if (cities != null && cities.isNotEmpty) "city": cities
      };
    }).toList();
  }

// Generate the final data structure (displayable text)
  String getSelectedLocationText() {
    if (selectedProvince.value.isNotEmpty) {
      if (selectedCity.value.isNotEmpty) {
        return '${selectedProvince.value}: ${selectedCity.value}';
      }
      return selectedProvince.value;
    }
    List<String> locationTexts = [];
    for (var province in selectedProvinces) {
      final cities = selectedCities[province] ?? [];
      if (cities.isNotEmpty) {
        locationTexts.add('$province: ${cities.join(', ')}');
      } else {
        locationTexts.add(province);
      }
    }
    return locationTexts.isNotEmpty
        ? locationTexts.join(', ')
        : 'Choose Location';
  }

  // ============== end of location ================== //

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await applyFilter(
      refresh: true,
      paginate: false,
    );
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    log.log("onLoading : ${userProductPostListRes.hasMore ?? false}");
    if (userProductPostListRes.hasMore ?? false) {
      await applyFilter(
        paginate: true,
        nextValue: itemList.last.createdAt,
      );
    }
    refreshController.loadComplete();
  }

  ProductPostListRes userProductPostListRes = ProductPostListRes();
  RxList<ProductModel> itemList = <ProductModel>[].obs;
  Map<String, dynamic>? filtermapPassed;
  RxString searchText = RxString('');
  TextEditingController searchController = TextEditingController();
  Future<void> applyFilter({
    bool refresh = false,
    bool paginate = false,
    String? nextValue,
  }) async {
    var map = {
      "category": (category.value?.name ?? '').toLowerCase(),
      "condition": accountType.value.toLowerCase(),
      "price_from": int.parse(priceFrom.value.text),
      "price_to": int.parse(priceTo.value.text),
      "location":
          getSelectedLocationData().isEmpty ? null : getSelectedLocationData(),
      "brand": brand.isEmpty ? [] : brandformate(),
      "body_type": bodyType.value != "Not Chosen Yet" ? [bodyType.value] : [],
      "drive_type":
          driveType.value != "Not Chosen Yet" ? [driveType.value] : [],
      "engine_type":
          engineType.value != "Not Chosen Yet" ? engineType.value : '',
      "transmission":
          transmission.value != "Not Chosen Yet" ? transmission.value : '',
      "color": color.isNotEmpty ? color : [],
      "credit": credit.value,
      "exchange": exchange.value,
      "has_vin_code": hasVinCode.value,
      'sort_price': sortDonwnToUp.value ? 1 : -1,
    };

    final filterData = Map<String, dynamic>.from(map);
    filterData.addAll(filtermapPassed ?? {});
    filtermapPassed = filterData;

    String url = Constants.baseUrl + Constants.postProduct;
    if (nextValue != null) {
      url = '$url?next=$nextValue';
    }
    log.log("filterData: $url $filterData");
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        'Authorization': Constants.token,
      },
      data: filterData,
      onLoading: () {
        if (refresh) {
          isFilterLoading.value = true;
          itemList.clear();
        }
      },
      onSuccess: (response) {
        Map<String, dynamic> responseData = response.data;
        userProductPostListRes = ProductPostListRes.fromJson(responseData);
        if (nextValue != null) {
          itemList.addAll(userProductPostListRes.data ?? []);
        } else {
          itemList.value = userProductPostListRes.data ?? [];
        }
        isFilterLoading.value = false;
      },
      onError: (error) {
        isFilterLoading.value = false;
        log.log("error: $error");
        log.log("error: ${error.response?.data}");
        Logger().d("$error <- error");
      },
    );
  }

  // ============== end of filter ================== //
  List<Map<String, dynamic>> brandformate() {
    List<Map<String, dynamic>> brandList = [];
    for (var brandAndModel in brandAndSelectedModel) {
      BrandModel brandSelected = brandAndModel["brand"];
      List<CarModel> brandModelSelected = brandAndModel["model"];
      Map<String, dynamic> tamp = {"brand": brandSelected.brand};
      if (brandModelSelected.isNotEmpty) {
        for (var model in brandModelSelected) {
          tamp["model"] = [
            {
              "name": model.name,
              "class": model.modelClass,
            }
          ];
        }
      }
      brandList.add(tamp);
    }
    return brandList;
  }
}

import 'package:alsat/app/modules/app_home/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:logger/logger.dart';

import '../../../../utils/constants.dart';
import '../../../common/const/image_path.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../services/base_client.dart';

class HomeController extends GetxController {
  RxBool isShowDrawer = false.obs;
  RxBool isShowSearch = false.obs;
  //home page variable
  RxInt homeBottomIndex = RxInt(0);
  RxInt categoryExpandedIndex = RxInt(0);
  List<Map<String, dynamic>> bottomBarItems = [
    {
      "icon": homeIcon,
      "name": 'Home',
    },
    {
      "icon": searchIcon,
      "name": 'Search',
    },
    {
      "icon": addPost,
      "name": 'Post Add',
    },
    {
      "icon": chatIcon,
      "name": 'Chat',
    },
    {
      "icon": profileIcon,
      "name": 'Profile',
    },
  ];
  PageController homePageController = PageController();

  RxList<CategoriesModel> categories = <CategoriesModel>[].obs;

  getCategories() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.categories,
      RequestType.get,
      onLoading: () {},
      onSuccess: (response) async {
        Logger().d(response.data.toString());
        // List<dynamic> data = response.data;
        // categories.value = data.map((json) => CategoriesModel.fromJson(json)).toList();
      },
      onError: (error) {
        Logger().d("$error <- error");
      },
    );
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
}

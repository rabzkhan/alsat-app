import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/const/image_path.dart';

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
      "icon": chatIcon,
      "name": 'Chat',
    },
    {
      "icon": categoryIcon,
      "name": 'Category',
    },
    {
      "icon": addPost,
      "name": 'Post Add',
    },
    {
      "icon": profileIcon,
      "name": 'Profile',
    },
  ];
  PageController homePageController = PageController();
}

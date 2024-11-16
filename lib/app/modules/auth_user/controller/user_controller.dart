import 'dart:developer';

import 'package:alsat/app/services/base_client.dart';
import 'package:alsat/utils/constants.dart';
import 'package:get/get.dart';

import '../../app_home/models/follower_res.dart';

class UserController extends GetxController {
  List<String> profileTab = [
    'My Listings',
    'Liked',
    'Followers',
    'Following',
  ];

  //-- Get user follower--//
  RxBool isFollowerLoading = true.obs;
  Rxn<FollowerRes> followerRes = Rxn<FollowerRes>();
  getUserFollower() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.follower,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isFollowerLoading.value = true;
        followerRes.value = null;
      },
      onSuccess: (response) async {
        log('follower response $response');
        Map<String, dynamic> data = response.data;
        followerRes.value = FollowerRes.fromJson(data);
        isFollowerLoading.value = false;
      },
      onError: (error) {
        log('follower error $error');
        isFollowerLoading.value = false;
        followerRes.value = null;
      },
    );
  }
}

import 'dart:developer';

import 'package:alsat/app/services/base_client.dart';
import 'package:alsat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../app_home/models/follower_res.dart';

class UserController extends GetxController {
  final userSettingsFormKey = GlobalKey<FormBuilderState>();
  final userNameTextController = TextEditingController().obs;

  List<String> profileTab = [
    'My Listings',
    'Liked',
    'Followers',
    'Following',
  ];

  //-- Get user follower--//
  RxBool isFollowerLoading = true.obs;

  RxList<FollowerModel> followerList = RxList<FollowerModel>();
  getUserFollower({String? next}) async {
    String url = Constants.baseUrl + Constants.follower;
    if (next != null) {
      url += '?next=$next';
    }
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        if (next == null) {
          isFollowerLoading.value = true;
          followerList.value = [];
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        FollowerRes followerRes = FollowerRes.fromJson(data);
        if (next != null) {
          followerList.addAll(followerRes.data ?? []);
        } else {
          followerList.value = followerRes.data ?? [];
        }
        followerList.refresh();
        isFollowerLoading.value = false;
      },
      onError: (error) {
        isFollowerLoading.value = false;
      },
    );
  }

  //-- Upgrade to premium--//
  RxBool isUpgradePreimumLoading = false.obs;

  //-- Get user following--//

  RxBool isFollowingLoading = true.obs;
  RxList<FollowerModel> followingList = RxList<FollowerModel>();
  getUserFollowing({String? next}) async {
    String url = Constants.baseUrl + Constants.following;
    if (next != null) {
      url += '?next=$next';
    }
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        if (next == null) {
          isFollowerLoading.value = true;
          followerList.value = [];
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        FollowerRes followerRes = FollowerRes.fromJson(data);
        if (next != null) {
          followerList.addAll(followerRes.data ?? []);
        } else {
          followerList.value = followerRes.data ?? [];
        }
        followerList.refresh();
        isFollowerLoading.value = false;
      },
      onError: (error) {
        isFollowerLoading.value = false;
      },
    );
  }
}

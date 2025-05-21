import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:alsat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:alsat/l10n/app_localizations.dart';

import '../../app_home/models/follower_res.dart';

class UserController extends GetxController {
  final userSettingsFormKey = GlobalKey<FormBuilderState>();

  List<String> profileTab(AppLocalizations appLocalizations) => [
        appLocalizations.my_listings,
        appLocalizations.liked,
        appLocalizations.followers,
        appLocalizations.following,
        appLocalizations.my_stories,
      ];
  //-- Upgrade to premium--//
  RxBool isUpgradePreimumLoading = false.obs;
  TextEditingController upgradeCodeController = TextEditingController();
  Future<void> upgradeToPremium() async {
    isUpgradePreimumLoading.value = true;
    try {
      return await BaseClient().safeApiCall(
        Constants.baseUrl + Constants.upgradeToPremium,
        DioRequestType.put,
        data: {
          'code': upgradeCodeController.text,
        },
        onSuccess: (response) async {
          upgradeCodeController.clear();

          isUpgradePreimumLoading.value = false;
          AuthController authController = Get.find();
          await authController.getProfile();
          Get.back();
          return null;
        },
        onError: (error) {
          isUpgradePreimumLoading.value = false;
          Get.back();
          CustomSnackBar.showCustomToast(message: "Invalid Code!");
        },
      );
    } catch (e) {
      isUpgradePreimumLoading.value = false;
      CustomSnackBar.showCustomToast(message: e.toString());
    }
  }

  //-- Get user follower--//
  RxBool isFollowerLoading = true.obs;
  RxList<FollowerModel> followerList = RxList<FollowerModel>();
  getUserFollower({String? next}) async {
    String url = Constants.baseUrl + Constants.follower;
    if (next != null) {
      url += '?next=$next';
    }
    await BaseClient().safeApiCall(
      url,
      DioRequestType.get,
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

  //-- Get user following--//

  RxBool isFollowingLoading = true.obs;
  RxList<FollowerModel> followingList = RxList<FollowerModel>();
  getUserFollowing({String? next}) async {
    String url = Constants.baseUrl + Constants.following;
    if (next != null) {
      url += '?next=$next';
    }
    await BaseClient().safeApiCall(
      url,
      DioRequestType.get,
      onLoading: () {
        if (next == null) {
          isFollowingLoading.value = true;
          followingList.value = [];
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        FollowerRes followerRes = FollowerRes.fromJson(data);
        if (next != null) {
          followingList.addAll(followerRes.data ?? []);
        } else {
          followingList.value = followerRes.data ?? [];
        }
        followingList.refresh();
        isFollowingLoading.value = false;
      },
      onError: (error) {
        isFollowingLoading.value = false;
      },
    );
  }
}

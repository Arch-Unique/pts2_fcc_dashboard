import 'dart:async';

import 'package:pts2_fcc/src/global/model/user.dart';
import 'package:pts2_fcc/src/global/services/barrel.dart';
import 'package:pts2_fcc/src/plugin/jwt.dart';
import 'package:pts2_fcc/src/src_barrel.dart';
import 'package:pts2_fcc/src/utils/constants/prefs/prefs.dart';
import 'package:get/get.dart';

class AppService extends GetxService {
  Rx<User> currentUser = User().obs;
  RxBool hasOpenedOnboarding = false.obs;
  RxBool isLoggedIn = false.obs;
  final apiService = Get.find<DioApiService>();
  final prefService = Get.find<MyPrefService>();

  initUserConfig() async {
    
      await _hasOpened();
      await _setLoginStatus();
      if (isLoggedIn.value) {
        await _setCurrentUser();
      }
  }

  loginUser() async {
    await _saveUser();
  }

  logout() async {
    await apiService.post(AppUrls.logout);
    await _logout();
  }

  _hasOpened() async {
    bool a = prefService.get(MyPrefs.hasOpenedOnboarding) ?? false;
    if (a == false) {
      await prefService.save(MyPrefs.hasOpenedOnboarding, true);
    }
    hasOpenedOnboarding.value = a;
  }

  _saveUser() async {
    await prefService.saveAll({
      MyPrefs.mpUserName: currentUser.value.username,
      MyPrefs.mpUserPass: currentUser.value.password,
      MyPrefs.mpIsLoggedIn:true
    });
  }

  _logout() async {
    await prefService.eraseAllExcept(MyPrefs.hasOpenedOnboarding);
  }

  _setCurrentUser() async {
    currentUser.value.username = prefService.get(MyPrefs.mpUserName);
    currentUser.value.password = prefService.get(MyPrefs.mpUserPass);
    _saveUser();
  }


  _setLoginStatus() async {
    isLoggedIn.value = prefService.get(MyPrefs.mpIsLoggedIn) ?? false;
  }



}

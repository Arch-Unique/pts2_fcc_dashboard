
import 'package:pts2_fcc/src/global/controller/connection_controller.dart';
import 'package:pts2_fcc/src/global/services/barrel.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';
import '../repo/app_repo.dart';

class AppDependency {
  static init() async {
    Get.put(MyPrefService());
    Get.put(DioApiService());
    await Get.putAsync(() async {
      final connectTivity = ConnectionController();
      await connectTivity.init();
      return connectTivity;
    });
    await Get.putAsync(() async {
      final appService = AppService();
      await appService.initUserConfig();
      return appService;
    });

    // //repos
    Get.put(AppRepo());
    // Get.put(DashboardRepo());
    // Get.put(ProfileRepo());
    // Get.put(FacilityRepo());

    // //controllers
    // Get.put(AuthController());
    Get.put(DashboardController());
    // Get.put(FacilityController());
  }
}

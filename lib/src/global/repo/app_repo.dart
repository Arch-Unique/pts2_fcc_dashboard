import 'package:get/get.dart';
import 'package:pts2_fcc/src/utils/constants/prefs/prefs.dart';

import '../../src_barrel.dart';
import '../model/barrel.dart';
import '../services/barrel.dart';

class AppRepo extends GetxController {
  final apiService = Get.find<DioApiService>();
  final prefService = Get.find<MyPrefService>();
  final appService = Get.find<AppService>();

  login(String url, String username, String password) async {
    prefService.save(MyPrefs.mpURL, url);
    prefService.save(MyPrefs.mpUserName, username);
    prefService.save(MyPrefs.mpUserPass, password);
    appService.currentUser.value = User(username: username, password: password);
    try {
      final dt = await getData([
        JsonPTSReq("GetDateTime"),
      ]);
      await appService.loginUser();
    } catch (e) {
      print(e);
      throw "Invalid Auth Credentials";
    }
  }

  Future<List<JsonPTSRes>> getData(List<JsonPTSReq> jpts) async {
    final res = await apiService.post(AppUrls.jsonPTS, data: {
      "Protocol": "jsonPTS",
      "Packets": List.generate(jpts.length, (i) {
        final v = {"Id": i + 1, "Type": jpts[i].title};
        if (jpts[i].data.isNotEmpty) {
          v["Data"] = jpts[i].data;
        }
        return v;
      }),
    });

    if (res.statusCode!.isSuccess()) {
      final vf = res.data["Packets"] as List;
      final vff = vf
          .map((item) => JsonPTSRes.fromJson(item as Map<String, dynamic>))
          .toList();
      return vff;
    } else {
      throw res.data?["error"] ?? "An error occured";
    }
  }
}

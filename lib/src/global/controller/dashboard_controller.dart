import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pts2_fcc/src/global/model/barrel.dart';
import 'package:pts2_fcc/src/global/repo/app_repo.dart';
import 'package:pts2_fcc/src/global/ui/functions/ui_functions.dart';
import 'package:pts2_fcc/src/src_barrel.dart';
import 'package:pts2_fcc/src/utils/constants/prefs/prefs.dart';

class DashboardController extends GetxController {
  RxList<PumpModel> allPumps = <PumpModel>[].obs;
  RxList<TankModel> allTanks = <TankModel>[].obs;
  RxList<PumpTrx> allPumpTrx = <PumpTrx>[].obs;
  RxBool isLoading = false.obs;
  RxInt curMode = 0.obs;
  final appRepo = Get.find<AppRepo>();

  int curPump = 1;
  DateTimeRange curDtr =
      DateTimeRange(start: DateTime.now().subtract(Duration(hours: 24)), end: DateTime.now());


  List<TextEditingController> tecs =
      List.generate(5, (i) => TextEditingController());
  final authKey = GlobalKey<FormState>();
  RxString connectionStatus = "".obs;
  RxBool isConnected = false.obs;
  RxString lastRefreshedDate = "".obs;

  onAuthPressed() async {
    try {
      if (authKey.currentState!.validate()) {
        await appRepo.login(tecs[0].text, tecs[1].text, tecs[2].text);
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      Ui.showError(e.toString());
    }
  }

  initTecs() {
    tecs[0].text = appRepo.prefService.get(MyPrefs.mpURL);
    tecs[1].text = appRepo.prefService.get(MyPrefs.mpUserName);
    tecs[2].text = "";
  }

  initPTData() async {
    try {
      isLoading.value = true;
      await initTecs();
      await initPTDataRaw();
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }

  initPTDataRaw() async {
    try {
      final dt = await appRepo.getData([
        JsonPTSReq("GetPumpsConfiguration"),
        JsonPTSReq("GetTanksConfiguration"),
      ]);

      //get pumps data
      final pumpsConfig = dt[0].data["Pumps"] as List;
      if (pumpsConfig.isNotEmpty) {
        final pt = await appRepo.getData(List.generate(pumpsConfig.length, (i) {
          return JsonPTSReq("PumpGetStatus",
              data: {"Pump": (pumpsConfig[i] as Map<String, dynamic>)["Id"]});
        }));
        allPumps.value = pt
            .map((ptt) =>
                PumpModel.fromJson({"Type": ptt.title, "Data": ptt.data}))
            .toList();
      }

      //get tanks data
      final tanksConfig = dt[1].data["Tanks"] as List;
      if (tanksConfig.isNotEmpty) {
        final tt = await appRepo.getData(List.generate(tanksConfig.length, (i) {
          return JsonPTSReq("ProbeGetMeasurements",
              data: {"Probe": (tanksConfig[i] as Map<String, dynamic>)["Id"]});
        }));
        allTanks.value = tt.map((ttt) => TankModel.fromJson(ttt.data)).toList();
      }

      isConnected.value = true;
      lastRefreshedDate.value =
          DateFormat("hh/MM/yyyy hh:mm:ss aa").format(DateTime.now());
    } catch (e) {
      isConnected.value = false;
    }
  }

  heartBeat() async {
    try {
      await appRepo.getData([
        JsonPTSReq("GetDateTime"),
      ]);
      isConnected.value = true;
    } catch (e) {
      isConnected.value = false;
    }
  }

  initPumpDetails() async {
    final dt = await appRepo.getData([
      JsonPTSReq("GetPumpsConfiguration"),
    ]);

    //get pumps data
    final pumpsConfig = dt[0].data["Pumps"] as List;
    final pt = await appRepo.getData(List.generate(pumpsConfig.length, (i) {
      return JsonPTSReq("PumpGetStatus",
          data: {"Pump": (pumpsConfig[i] as Map<String, dynamic>)["Id"]});
    }));
    allPumps.value = pt
        .map((ptt) => PumpModel.fromJson({"Type": ptt.title, "Data": ptt.data}))
        .toList();
  }

  initTankDetails() async {
    final dt = await appRepo.getData([
      JsonPTSReq("GetTanksConfiguration"),
    ]);

    //get tanks data
    final tanksConfig = dt[1].data["Tanks"] as List;
    final tt = await appRepo.getData(List.generate(tanksConfig.length, (i) {
      return JsonPTSReq("ProbeGetMeasurements",
          data: {"Probe": (tanksConfig[i] as Map<String, dynamic>)["Id"]});
    }));
    allTanks.value = tt.map((ttt) => TankModel.fromJson(ttt.data)).toList();
  }

  getAllPumpsTransaction() async {
    try {
      isLoading.value = true;
      final dt = await appRepo.getData([
        JsonPTSReq("ReportGetPumpTransactions", data: {
          "Pump": curPump,
          "DateTimeStart": DateFormat("yyyy-MM-ddThh:mm:ss").format(curDtr.start),
          "DateTimeEnd": DateFormat("yyyy-MM-ddThh:mm:ss").format(curDtr.end),
        }),
      ]);
      final apt = (dt[0].data as List)
          .map((fg) => PumpTrx.fromJson(fg as Map<String, dynamic>))
          .toList();

      allPumpTrx.value = apt.reversed.toList();
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }
}

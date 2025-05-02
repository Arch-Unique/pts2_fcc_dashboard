import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pts2_fcc/src/features/shared.dart';
import 'package:pts2_fcc/src/global/controller/dashboard_controller.dart';
import 'package:pts2_fcc/src/global/ui/widgets/others/containers.dart';
import 'package:pts2_fcc/src/src_barrel.dart';

import '../global/ui/ui_barrel.dart';
import '../global/ui/widgets/fields/custom_textfield.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.find<DashboardController>();
  final screens = [
    PumpScreen(),
    TankScreen(),
    TxScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    controller.initPTData();
    Timer.periodic(Duration(seconds: 30), (t) async {
      await controller.initPTDataRaw();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("${Ui.width(context)}  ${Ui.height(context)}");
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Ui.boxHeight(24),
              Ui.padding(
                child: Row(
                  children: [
                    AppText.bold("Dashboard"),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      AppText.medium("Update FCC Info",
                                          fontSize: 18),
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: AppIcon(Icons.close))
                                    ],
                                  ),
                                  backgroundColor: AppColors.containerColor,
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 720),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextField(
                                          "https://192.168.0.1",
                                          controller.tecs[0],
                                          label: "FCC Url",
                                        ),
                                        CustomTextField(
                                          "admin",
                                          controller.tecs[1],
                                          label: "FCC username",
                                        ),
                                        CustomTextField.password(
                                          "*****",
                                          controller.tecs[2],
                                          label: "FCC password",
                                        ),
                                        AppButton(
                                          onPressed: () async {
                                            await controller.onAuthPressed();
                                          },
                                          text: "Update",
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: AppIcon(Icons.settings))
                  ],
                ),
              ),
              Ui.padding(
                child: Row(
                  children: List.generate(DashboardModes.values.length, (i) {
                    return DashboardItem(DashboardModes.values[i]);
                  }),
                ),
              ),
              Expanded(child: Obx(() {
                // controller.initPTDataRaw();
                return screens[controller.curMode.value];
              })),
              Obx(() {
                return CurvedContainer(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  color: controller.isConnected.value
                      ? AppColors.primaryColor
                      : AppColors.red,
                  child: Center(
                    child: AppText.thin(
                        controller.isConnected.value
                            ? "ONLINE - Last Refreshed: ${controller.lastRefreshedDate.value}"
                            : "OFFLINE - Last Refreshed: ${controller.lastRefreshedDate.value}",
                        alignment: TextAlign.center),
                  ),
                );
              })
            ],
          ),
        ),
      )),
    );
  }
}

class DashboardItem extends StatelessWidget {
  const DashboardItem(this.dm, {super.key});
  final DashboardModes dm;

  @override
  Widget build(BuildContext context) {
    final vb = Get.find<DashboardController>().curMode;
    return Obx(() {
      return Expanded(
        flex: dm.index == vb.value ? 2 : 1,
        child: CurvedContainer(
          color: dm.index == vb.value
              ? AppColors.accentColor
              : AppColors.containerColor,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(4),
          onPressed: () {
            vb.value = dm.index;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                dm.icon,
                size: 14,
              ),
              Ui.boxWidth(8),
              Obx(() {
                return AppText(dm.title,
                    weight: dm.index == vb.value
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 14);
              }),
            ],
          ),
        ),
      );
    });
  }
}

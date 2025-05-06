import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pts2_fcc/src/global/controller/dashboard_controller.dart';
import 'package:pts2_fcc/src/global/model/barrel.dart';
import 'package:pts2_fcc/src/global/ui/ui_barrel.dart';
import 'package:pts2_fcc/src/global/ui/widgets/fields/custom_dropdown.dart';
import 'package:pts2_fcc/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:pts2_fcc/src/global/ui/widgets/others/containers.dart';
import 'package:pts2_fcc/src/src_barrel.dart';

class PumpItemWidget extends StatelessWidget {
  const PumpItemWidget(this.pm, {super.key});
  final PumpModel pm;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
constraints: BoxConstraints(
        maxWidth: 348,
        minWidth: Ui.width(context) > 720 ? 348 : (Ui.width(context)/2)-16,
      ),
      child: CurvedContainer(
        color: AppColors.containerColor,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        onPressed: (){
          Get.find<DashboardController>().curPump = pm.pump;
          Get.find<DashboardController>().curDtr = DateTimeRange(start: DateTime.now().subtract(Duration(hours: 24)), end: DateTime.now());
          Get.find<DashboardController>().curMode.value = 2;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText.medium("Pump ${pm.pump}"),
                Spacer(),
                CurvedContainer(
                  padding: EdgeInsets.all(8),
                  color: AppColors.containerColor,
                  child: AppText.medium(pm.lastFuelGradeName)),
              ],
            ),
            CurvedContainer(
              color: AppColors.black.withOpacity(0.7),
              margin: EdgeInsets.symmetric(
                vertical: 16,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.medium(pm.lastAmount.toCurrency(), fontSize: 14),
                  AppText.thin("Last Tx Amt", fontSize: 12),
                  AppDivider(),
                  AppText.medium("${pm.lastVolume} L", fontSize: 14),
                  AppText.thin("Last Volume", fontSize: 12),
                  AppDivider(),
                  AppText.medium(pm.lastPrice.toCurrency(), fontSize: 14),
                  AppText.thin("Price", fontSize: 12),
                  AppDivider(),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      
                      child: AppText.medium(pm.stateRaw.toUpperCase(),color: pm.stateRaw == "idle" ? AppColors.accentColor: pm.stateRaw == "offline" ? AppColors.grey: AppColors.primaryColor,),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PumpScreen extends StatelessWidget {
  PumpScreen({super.key});
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgress(56));
      }
      if (controller.allPumps.isEmpty) {
        return Center(
          child: AppText.thin("No Pumps Found"),
        );
      }
      return SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.allPumps.map((f) => PumpItemWidget(f)).toList(),
        ),
      );
    });
  }
}

class TankItemWidget extends StatelessWidget {
  const TankItemWidget(this.tm, {super.key});
  final TankModel tm;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 348,
        minWidth: Ui.width(context) > 720 ? 348 : (Ui.width(context)/2)-16,
      ),
      child: CurvedContainer(
        color: AppColors.containerColor,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText.medium("Tank ${tm.probe}"),
                Spacer(),
                AppText.medium(tm.fuelGradeName),
              ],
            ),
            CurvedContainer(
              color: AppColors.containerColor,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              child: Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CurvedContainer(
                        radius: 16,
                        height: 120,
                        width: 56,
                        color: AppColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CurvedContainer(
                              radius: 16,
                              height: ((tm.tankFillingPercentage * 120) / 100),
                              width: 56,
                              color: AppColors.accentColor,
                            ),
                          ],
                        ),
                      ),
                      AppText.thin("${tm.tankFillingPercentage}%",
                          color: AppColors.black)
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.medium("${tm.productVolume} L", fontSize: 14),
                          AppText.thin("Product Volume", fontSize: 12),
                          AppDivider(),
                          AppText.medium("${tm.waterVolume} L", fontSize: 14),
                          AppText.thin("Water Volume", fontSize: 12),
                          AppDivider(),
                          AppText.medium("${tm.totalCapacity} L", fontSize: 14),
                          AppText.thin("Total Capacity", fontSize: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TankScreen extends StatelessWidget {
  TankScreen({super.key});
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgress(56));
      }
      if (controller.allTanks.isEmpty) {
        return Center(
          child: AppText.thin("No Tanks Found"),
        );
      }
      return SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.allTanks.map((f) => TankItemWidget(f)).toList(),
        ),
      );
    });
  }
}

class TxItemWidget extends StatelessWidget {
  const TxItemWidget(this.pt, {super.key});
  final PumpTrx pt;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
        color: AppColors.containerColor,
        padding: EdgeInsets.all(16),
        radius: 0,
        border: Border(bottom: BorderSide(color: AppColors.grey)),
        child: Row(
          children: [
            Expanded(
                child: AppText.thin(
                    DateFormat("dd/MM/yyyy hh:mm aa").format(pt.dateTimeStart),alignment: TextAlign.center,
                    fontSize: 12)),
            Expanded(
                child: AppText.thin("${pt.pump} | ${pt.fuelGradeName}",alignment: TextAlign.center,
                    fontSize: 14)),
            Expanded(child: AppText.thin("${pt.volume} L", fontSize: 12,alignment: TextAlign.center,)),
            Expanded(child: AppText.thin(pt.amount.toCurrency(), fontSize: 12,alignment: TextAlign.center,)),
          ],
        ));
  }
}

class TxScreen extends StatefulWidget {
  const TxScreen({super.key});

  @override
  State<TxScreen> createState() => _TxScreenState();
}

class _TxScreenState extends State<TxScreen> {
  final controller = Get.find<DashboardController>();
  final TextEditingController tec = TextEditingController();


  @override
  void initState() {
    controller.getAllPumpsTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ui.padding(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: CustomDropdown.days(
                      hint: "",
                      selectedValue: controller.curPump,
                      onChanged: (i) {
                        controller.curPump = i ?? 0;
                      })),
              Ui.boxWidth(8),
              Expanded(
                  flex: 3,
                  child: CustomTextField(
                    "Date Start - Date End",
                    tec,
                    label: "Date Range",
                    readOnly: true,
                    onTap: () async {
                      final dtr = await showDateRangePicker(
                          context: context,

                          builder: (c,child){
                            return Theme(
                              data: ThemeData.dark(),
                              child: child!);
                          },
                          firstDate:
                              DateTime.now().subtract(Duration(days: 1800)),
                          lastDate: DateTime.now());
                      if (dtr != null) {
                        controller.curDtr = DateTimeRange(
                            start: DateTime(dtr.start.year, dtr.start.month,
                                dtr.start.day,1,0,0),
                            end: DateTime(dtr.end.year, dtr.end.month,
                                dtr.end.day,23,59,59));
                        tec.text =
                            "${DateFormat("dd/MM/yyyy hh:mm aa").format(controller.curDtr.start)} - ${DateFormat("dd/MM/yyyy hh:mm aa").format(controller.curDtr.end)}";
                      }
                    },
                  )),
              Ui.boxWidth(8),
              Expanded(
                  child: AppButton(
                onPressed: () async {
                  await controller.getAllPumpsTransaction();
                },
                text: "Apply",
              ))
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
                child: AppText.thin("Date",
                    fontSize: 14, alignment: TextAlign.center)),
            Expanded(
                child: AppText.thin("Pump No",
                    fontSize: 14, alignment: TextAlign.center)),
            Expanded(
                child: AppText.thin("Volume",
                    fontSize: 14, alignment: TextAlign.center)),
            Expanded(
                child: AppText.thin("Amount",
                    fontSize: 14, alignment: TextAlign.center)),
          ],
        ),
        Ui.boxHeight(12),
        Expanded(
            child: Obx(
               () {
                return ListView.builder(
                          itemBuilder: (c, i) {
                return TxItemWidget(controller.allPumpTrx[i]);
                          },
                          itemCount: controller.allPumpTrx.length,
                        );
              }
            )),
            Ui.boxHeight(12),
            Row(
          children: [
            Expanded(
              flex: 2,
                child: AppText.thin("TOTAL",
                    fontSize: 14, alignment: TextAlign.center)),
           
            Expanded(
                child: Obx(
                   () {
                    return AppText.medium("${controller.allPumpTrx.map((f) => f.volume).fold(0.0,(a,b) => a+b).toStringAsFixed(2)} L",
                        fontSize: 14, alignment: TextAlign.center);
                  }
                )),
            Expanded(
                child: Obx(
                   () {
                    return AppText.medium(controller.allPumpTrx.map((f) => f.amount).fold(0.0,(a,b) => a+b).toCurrency(),
                        fontSize: 14, alignment: TextAlign.center);
                  }
                )),
          ],
        ),
        Ui.boxHeight(12),
      ],
    );
  }
}

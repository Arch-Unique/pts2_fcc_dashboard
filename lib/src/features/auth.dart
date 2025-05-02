import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pts2_fcc/src/features/dashboard.dart';
import 'package:pts2_fcc/src/global/controller/dashboard_controller.dart';
import 'package:pts2_fcc/src/global/ui/ui_barrel.dart';
import 'package:pts2_fcc/src/global/ui/widgets/fields/custom_textfield.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Ui.padding(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: 720
                ),
              child: Form(
                key: controller.authKey,
                child: Column(
                  children: [
                    Ui.boxHeight(24),
                    AppText.bold("Log In"),
                    const Spacer(),
                    CustomTextField("https://192.168.0.1", controller.tecs[0],label: "FCC Url",),
                    CustomTextField("admin", controller.tecs[1],label: "FCC username",),
                    CustomTextField.password("*****", controller.tecs[2],label: "FCC password",),
                    const Spacer(),
                    Ui.boxHeight(24),
                    AppButton(onPressed: () async{
                     await controller.onAuthPressed();
                    },text: "Submit",),
                    Ui.boxHeight(24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
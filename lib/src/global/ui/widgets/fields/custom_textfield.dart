import 'package:flutter/material.dart';
import 'package:pts2_fcc/src/utils/formatters/num_formatters.dart';
import 'package:icons_plus/icons_plus.dart';
import '/src/src_barrel.dart';

import '../../ui_barrel.dart';

class CustomTextField extends StatelessWidget {
  final String hint, label;
  final TextEditingController controller;
  final FPL varl;
  final Color col, iconColor,fillcolor;
  final VoidCallback? onTap, customOnChanged;
  final TextInputAction tia;
  final dynamic suffix;
  final bool autofocus, hasBottomPadding;
  final double fs;
  final FontWeight fw;
  final bool readOnly, shdValidate;
  final TextAlign textAlign;
  final String? oldPass;
  const CustomTextField(this.hint, this.controller,
      {this.varl = FPL.text,
      this.label = "",
      this.fs = 14,
      this.hasBottomPadding = true,
      this.fw = FontWeight.w300,
      this.col = AppColors.textColor,
      this.iconColor = AppColors.primaryColor,
      this.fillcolor = AppColors.transparent,
      this.tia = TextInputAction.next,
      this.oldPass,
      this.onTap,
      this.autofocus = false,
      this.customOnChanged,
      this.readOnly = false,
      this.shdValidate = true,
      this.textAlign = TextAlign.start,
      this.suffix,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool isShow = varl == FPL.password;
    String? vald;
    // Color borderCol =
    //     suffix != null ? AppColors.borderCol : AppColors.primaryColor;
    Color borderCol = AppColors.borderColor;
    // bool hasTouched = false;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: Ui.width(context) - 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty)
              Ui.align(
                child: AppText.thin(label, fontSize: 14,),
              ),
            if (label.isNotEmpty) Ui.boxHeight(4),
            TextFormField(
              controller: controller,
              readOnly: readOnly,
              textAlign: textAlign,
              autofocus: autofocus,
              onChanged: (s) async {
                // if (s.isNotEmpty) {
                //   setState(() {
                //     hasTouched = true;
                //   });
                // } else {
                //   setState(() {
                //     hasTouched = false;
                //   });
                // }
                if (customOnChanged != null) customOnChanged!();
              },
              keyboardType: varl.textType,
              textInputAction: tia,
              maxLines: varl == FPL.multi ? 5 : 1,
              maxLength: varl.maxLength,
              onTap: onTap,
              inputFormatters: [
                if (varl == FPL.cardNo) CreditCardFormatter(),
                if (varl == FPL.money) ThousandsFormatter(),
                // if (varl == FPL.dateExpiry) DateInputFormatter()
              ],
              validator: shdValidate
                  ? (value) {
                      // setState(() {
                      vald = oldPass == null
                          ? Validators.validate(varl, value)
                          : Validators.confirmPasswordValidator(
                              value, oldPass!);

                      //   Future.delayed(const Duration(seconds: 1), () {
                      //     vald = null;
                      //   });
                      // });
                      return vald;
                    }
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
              obscureText: varl == FPL.password && isShow,
              textAlignVertical:
                  varl == FPL.multi ? TextAlignVertical.top : null,
              decoration: InputDecoration(
                fillColor: fillcolor,
                filled: false,
                enabledBorder: customBorder(
                    color: borderCol),
                focusedBorder: customBorder(color: borderCol),
                border: customBorder(
                    color: borderCol),
                focusedErrorBorder: customBorder(color: AppColors.red),
                counter: SizedBox.shrink(),
                errorStyle: const TextStyle(fontSize: 12, color: AppColors.red),
                errorBorder: customBorder(color: borderCol),
                suffixIconConstraints: suffix != null
                    ? BoxConstraints(minWidth: 24, minHeight: 24)
                    : null,
                isDense: suffix != null,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                suffixIcon: suffix != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: AppIcon(suffix,
                            color:
                                // hasTouched
                                //     ? AppColors.textColor
                                //     :
                                iconColor),
                      )
                    : varl == FPL.password
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isShow = !isShow;
                              });
                            },
                            icon: AppIcon(
                                isShow ? Iconsax.eye_outline : Iconsax.eye_slash_outline,
                                color:
                                    // hasTouched
                                    //     ? AppColors.textColor
                                    //     :
                                    AppColors.white))
                        : null,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: fs,
                    fontWeight: FontWeight.w400,
                    color: borderCol),
              ),
            ),
            SizedBox(
              height: hasBottomPadding ? 24 : 0,
            )
            // vald == null
            //     ? const SizedBox(
            //         height: 24,
            //       )
            //     : Align(
            //         alignment: Alignment.centerLeft,
            //         child: Padding(
            //           padding: EdgeInsets.only(top: 8, bottom: 24),
            //           child: AppText.thin("$vald",
            //               fontSize: 12, color: AppColors.red),
            //         ))
          ],
        ),
      );
    });
  }

  static bool isUserVal(String s) {
    return !(s.isEmpty || s.contains(RegExp(r'[^\w.]')) || s.length < 8);
  }

  InputBorder customBorder({Color color = AppColors.textColor}) {
    // return OutlineInputBorder(
    //   borderSide: BorderSide(color: color),
    //   borderRadius: BorderRadius.circular(8),
    //   gapPadding: 8,
    // );

    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(48),
      gapPadding: 8,
    );
    // return InputBorder.none;
  }

  static password(String hint, TextEditingController controller,
      {String? oldPass,
      String label = "Password",
      TextInputAction tia = TextInputAction.done,
      bool hbp = true}) {
    return CustomTextField(
      hint,
      controller,
      tia: tia,
      varl: FPL.password,
      oldPass: oldPass,
      label: label,
      hasBottomPadding: hbp,
    );
  }

  // static search(String hint, TextEditingController controller,
  //     VoidCallback customOnChanged) {
  //   return CustomTextField(hint, controller,
  //       hasBottomPadding: false,
  //       shdValidate: false,
  //       suffix: Assets.search38,
  //       customOnChanged: customOnChanged);
  // }
}

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils_barrel.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  number(TextInputType.number),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 1000, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.number),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum AuthMode {
  login("Log In", "Login with one following options", "Create Account"),
  register("Create Account", "You can sign up with one following options",
      "Have an Account? Login!");

  final String title, desc, afterAction;
  const AuthMode(this.title, this.desc, this.afterAction);
}

enum SuccessPagesMode {
  password("Password reset link sent",
      "Check your emails for the link sent to reset your Biko account password"),
  register("Confirm your account",
      "Check your emails for the link sent to confirm your Biko account");

  final String title, desc;
  const SuccessPagesMode(this.title, this.desc);
}

enum ThirdPartyTypes {
  facebook(Brands.facebook_f),
  google(Brands.google),
  apple(Brands.apple_logo);

  final String logo;
  const ThirdPartyTypes(this.logo);
}

enum DashboardModes {
  editprofile("Pumps", Icons.gas_meter_outlined),
  account("Tanks", Icons.propane_tank_outlined),
  wallet("Transactions", Icons.money);

  final String title;
  final dynamic icon;
  const DashboardModes(this.title, this.icon);
}

enum CardColors {
  card1(Color(0xFF202325)),
  card2(Color(0xFF012c4a)),
  card3(Color(0xFFE0F8E7)),
  card4(Color(0xFFE0F8E7)),
  card5(Color(0XFFD4FCFF));

  final Color color;
  const CardColors(this.color);
}

enum ErrorTypes {
  noInternet(Icons.wifi_tethering_off_rounded, "No Internet Connection",
      "Please check your internet connection and try again"),

  noPatient(Icons.pregnant_woman_rounded, "No Patient Found",
      "Oops. no patients found. Please contact support for help"),
  noDonation(Iconsax.empty_wallet_outline, "No Donation Found",
      "You haven't made any donations yet. Why not make a difference today? "),
  serverFailure(Icons.power_off_rounded, "Server Failure",
      "Something bad happened. Please try again later");

  final String title, desc;
  final dynamic icon;
  const ErrorTypes(this.icon, this.title, this.desc);
}

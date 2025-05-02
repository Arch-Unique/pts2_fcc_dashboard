import 'package:pts2_fcc/src/utils/constants/countries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/src/src_barrel.dart';
import '../../ui_barrel.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint, label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final Color iconColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool hasBottomPadding;
  final bool isEnabled;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.label = "",
    this.iconColor = AppColors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w300,
    this.hasBottomPadding = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.borderColor;
    return SizedBox(
      width: Ui.width(context) - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Ui.align(
              child: AppText.medium(label, fontSize: 14),
            ),
          if (label.isNotEmpty) Ui.boxHeight(4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonFormField<T>(
              value: value,
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: AppIcon(Icons.keyboard_arrow_down_rounded,
                    color: iconColor),
              ),
              decoration: InputDecoration(
                fillColor: AppColors.transparent,
                filled: false,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: borderColor,
                ),
              ),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: AppColors.textColor,
              ),
              dropdownColor: AppColors.containerColor,
              items: isEnabled ? items : [],
              onChanged: isEnabled ? onChanged : null,
            ),
          ),
          SizedBox(
            height: hasBottomPadding ? 24 : 0,
          ),
        ],
      ),
    );
  }

  // Factory constructor for country selector dropdown
  static CustomDropdown<String> country({
    required String hint,
    required String? selectedValue,
    required Function(String?) onChanged,
    String label = "Country",
    bool hasBottomPadding = true,
  }) {
    // You can add more countries as needed
    final countries = countriesData;


    return CustomDropdown<String>(
      hint: hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: countries.map((country) {
        return DropdownMenuItem<String>(
          value: country['code'],
          child: Row(
            children: [
              Text(country['flag']!),
              SizedBox(width: 8),
              Text(country['name']!),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for number of days dropdown
  static CustomDropdown<int> days({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    String label = "Pump",
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = List.generate(30, (index) => index + 1);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: Text(day.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
    
    
    static CustomDropdown<int> months({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = List.generate(12, (index) => index + 1);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: Text(DateFormat("MMMM").format(DateTime(2025,day))),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

      static CustomDropdown<int> years({
    required String hint,
    required int? selectedValue,
    required Function(int?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<int> days = List.generate(50, (index) => index + 2025);

    return CustomDropdown<int>(
      hint: hint,
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: days.map((day) {
        return DropdownMenuItem<int>(
          value: day,
          child: Text(day.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for city dropdown
  static CustomDropdown<String> city({
    required String hint,
    required String? selectedValue,
    required Function(String?) onChanged,
    String label = "Number of Days",
    bool hasBottomPadding = true,
  }) {
    // Generate days from 1 to 30 (can be adjusted as needed)
    final List<String> cities = ["Lagos", "Abuja", "Nairobi"];

    return CustomDropdown<String>(
      hint: hint,
      value: selectedValue,
      label: label,
      hasBottomPadding: hasBottomPadding,
      items: cities.map((day) {
        return DropdownMenuItem<String>(
          value: day,
          child: AppText.thin(day.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // Factory constructor for phone country code dropdown
  static CustomDropdown<String> phoneCountryCode({
    required String? selectedValue,
    required Function(String?) onChanged,
    bool hasBottomPadding = true,
  }) {
    // You can add more country codes as needed
    final countryCodes = [
      {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
      {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
      {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
      {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
      {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    ];

    return CustomDropdown<String>(
      hint: "+1",
      value: selectedValue,
      hasBottomPadding: hasBottomPadding,
      items: countryCodes.map((country) {
        return DropdownMenuItem<String>(
          value: country['code'],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country['flag']!),
              SizedBox(width: 4),
              Text(country['code']!, style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

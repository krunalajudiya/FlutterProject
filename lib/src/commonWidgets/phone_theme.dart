import 'package:flutter/material.dart';

import '../constants/ColorCode.dart';

class PhoneTheme {
  static ThemeData theme() {
    return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            primary: Color(ColorCode.primaryColor), surfaceTint: Colors.white),
        appBarTheme: AppBarTheme(
          foregroundColor: ColorCode.appbarForgroundColor,
          elevation: 4,
          shadowColor: Colors.grey.shade100,
          color: const Color(ColorCode.primaryColor),
        ),
        chipTheme: ChipThemeData(
          selectedColor: ColorCode.chipSelectedColor.shade200,
          backgroundColor: ColorCode.chipBackgroundColor.shade100,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.grey.shade300;
                  }
                  return const Color(ColorCode.primaryColor);
                }),
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => ColorCode.buttonForgroundColor))));
  }
}

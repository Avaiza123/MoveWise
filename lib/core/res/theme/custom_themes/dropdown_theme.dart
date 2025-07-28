// import 'package:demo/core/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import '../../colors/colors.dart';
//
// class AppDropdownMenuTheme {
//   AppDropdownMenuTheme._();
//
//   static DropdownMenuThemeData lightDropdownMenuTheme = DropdownMenuThemeData(
//     menuStyle: MenuStyle(
//       backgroundColor: WidgetStateProperty.all(AppColors.lightGrey), // Light gray background
//       elevation: WidgetStateProperty.all(8.0),
//       shape: WidgetStateProperty.all(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: AppColors.secondary, width: 1), // Dark grey border
//         ),
//       ),
//     ),
//     textStyle:  TextStyle(
//       color: AppColors.black,
//       fontSize: AppSizes.fontSizeMd,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: AppColors.darkGrey), // Dark grey border
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: AppColors.darkGrey), // Dark grey border
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: AppColors.primary), // Blue border when focused
//       ),
//     ),
//   );
//
//   static DropdownMenuThemeData darkDropdownMenuTheme = DropdownMenuThemeData(
//     menuStyle: MenuStyle(
//       backgroundColor: WidgetStateProperty.all(AppColors.secondary), // Dark gray background
//       elevation: WidgetStateProperty.all(8.0),
//       shape: WidgetStateProperty.all(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: AppColors.secondary, width: 1), // Light grey border
//         ),
//       ),
//     ),
//     textStyle:  TextStyle(
//       color: AppColors.white,
//       fontSize: AppSizes.fontSizeMd,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: AppColors.primary), // Blue border when focused
//       ),
//     ),
//   );
// }
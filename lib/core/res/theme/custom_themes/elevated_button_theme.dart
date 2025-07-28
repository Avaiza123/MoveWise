// import 'package:flutter/material.dart';
// import '../../../utils/constants/sizes.dart';
// import '../../colors/colors.dart';
//
// /* -- Light & Dark Elevated Button Themes -- */
// class AppElevatedButtonTheme {
//   AppElevatedButtonTheme._(); //To avoid creating instances
//
//
//   static final lightElevatedButtonTheme = ElevatedButtonThemeData(
//     style: ButtonStyle(
//       minimumSize: WidgetStateProperty.all(Size(double.infinity, AppSizes.buttonHeight)),
//       elevation: WidgetStateProperty.all(0),
//       foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
//         if (states.contains(WidgetState.disabled)) {
//           return AppColors.buttonDisableTitle; // Background when disabled
//         }
//         return AppColors.white; // Background when enabled
//       }),
//       backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
//         if (states.contains(WidgetState.disabled)) {
//           return AppColors.extraLightGrey; // Background when disabled
//         }
//         return AppColors.primary; // Background when enabled
//       }),
//       side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
//         if (states.contains(WidgetState.disabled)) {
//           return null; // No border when disabled
//         }
//         return const BorderSide(color: AppColors.primary); // Border when enabled
//       }),
//
//
//       padding: WidgetStateProperty.all(
//          EdgeInsets.symmetric(vertical: AppSizes.mdh, horizontal: AppSizes.mdLgw),
//       ),
//       textStyle: WidgetStateProperty.all(
//          TextStyle(
//           fontSize: AppSizes.buttonText,
//           color: AppColors.textWhite,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       shape: WidgetStateProperty.all(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
//         ),
//       ),
//     ),
//   );
//
//
//   /* -- Dark Theme -- */
//   static final darkElevatedButtonTheme = ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       elevation: 0,
//       foregroundColor: AppColors.light,
//       backgroundColor: AppColors.primary,
//       disabledForegroundColor: AppColors.darkGrey,
//       disabledBackgroundColor: AppColors.darkerGrey,
//       side: const BorderSide(color: AppColors.primary),
//       padding:  EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
//       textStyle:  TextStyle(fontSize: AppSizes.buttonText, color: AppColors.textWhite, fontWeight: FontWeight.w700),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
//     ),
//   );
// }

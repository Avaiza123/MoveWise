// import 'package:flutter/material.dart';
//
// import '../../../utils/constants/sizes.dart';
// import '../../colors/colors.dart';
//
// class AppTextButtonTheme {
//   AppTextButtonTheme._(); // To avoid creating instances
//
//   static final lightTextButtonTheme = TextButtonThemeData(
//     style: ButtonStyle(
//       foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
//         if (states.contains(WidgetState.disabled)) {
//           return AppColors.buttonDisableTitle; // Color when disabled
//         }
//         return AppColors.primary; // Color when enabled
//       }),
//       padding: WidgetStateProperty.all(EdgeInsets.zero), // Padding set to zero
//       overlayColor: WidgetStateProperty.all(Colors.transparent), // No overlay color when pressed
//       minimumSize: WidgetStateProperty.all(Size.zero), // Minimum size set to zero
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks tap target size
//       textStyle: WidgetStateProperty.all(
//          TextStyle(
//           fontSize: AppSizes.fontSizeXm,
//           color: AppColors.primary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   );
//
//   /* -- Dark Theme -- */
//   static final darkTextButtonTheme = TextButtonThemeData(
//     style: ButtonStyle(
//       foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
//         if (states.contains(WidgetState.disabled)) {
//           return AppColors.buttonDisableTitle; // Color when disabled
//         }
//         return AppColors.primary; // Color when enabled
//       }),
//       padding: WidgetStateProperty.all(EdgeInsets.zero), // Padding set to zero
//       overlayColor: WidgetStateProperty.all(Colors.transparent), // No overlay color when pressed
//       minimumSize: WidgetStateProperty.all(Size.zero), // Minimum size set to zero
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks tap target size
//       textStyle: WidgetStateProperty.all(
//          TextStyle(
//           fontSize: AppSizes.fontSizeXm,
//           color: AppColors.primary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   );
// }

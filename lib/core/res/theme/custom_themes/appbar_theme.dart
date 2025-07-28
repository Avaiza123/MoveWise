// import 'package:flutter/material.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../utils/app_colors.dart';
// //import '../../../utils/constants/sizes.dart';
// import '../../colors/colors.dart';
//
// class AppAppBarTheme {
//   AppAppBarTheme._();

  // static var lightAppBarTheme = AppBarTheme(
  //   elevation: 0,
  //   centerTitle: false,
  //   scrolledUnderElevation: 0,
  //   backgroundColor: Colors.transparent,
  //   surfaceTintColor: Colors.transparent,
  //   iconTheme: IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
  //   actionsIconTheme:
  //        IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
  //   titleTextStyle:  TextStyle(
  //       fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: AppColors.black),
  // );
//   static var darkAppBarTheme = AppBarTheme(
//     elevation: 0,
//     centerTitle: false,
//     scrolledUnderElevation: 0,
//     backgroundColor: Colors.transparent,
//     surfaceTintColor: Colors.transparent,
//     iconTheme:  IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
//     actionsIconTheme:
//          IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
//     titleTextStyle:  TextStyle(
//         fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: AppColors.white),
//   );
// }


import 'package:flutter/material.dart';
import 'package:movewise/core/constants/app_colors.dart';

final appBarTheme = AppBarTheme(
  backgroundColor: AppColors.primaryColor,
  foregroundColor: Colors.white,
  centerTitle: true,
  elevation: 0,
  titleTextStyle: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

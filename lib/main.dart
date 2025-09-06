import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:movewise/core/res/routes/routes.dart';
import 'package:movewise/core/res/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoveWise',
      // theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      getPages: AppRoute.appRoutes(), // ✅ CORRECTED HERE
      initialRoute: '/welcome_screen', // 🔄 Optional: define your start screen route
    );
  }
}

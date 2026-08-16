import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(const HabotConnectApp());
}


class HabotConnectApp extends StatelessWidget {
  const HabotConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HabotConnect — LSA Verification',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}

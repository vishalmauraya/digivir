import 'package:get/get.dart';

import '../modules/lsa_profile_verification/bindings/lsa_profile_verification_binding.dart';
import '../modules/lsa_profile_verification/views/lsa_profile_verification_view.dart';
import 'app_routes.dart';


abstract class AppPages {
  AppPages._();

  static const String initial = AppRoutes.lsaProfileVerification;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.lsaProfileVerification,
      page: () => const LSAProfileVerificationView(),
      binding: LSAProfileVerificationBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}

import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/repositories/lsa_profile_repository.dart';
import '../../../data/repositories/lsa_profile_repository_impl.dart';
import '../../../data/repositories/lsa_profile_repository_mock.dart';
import '../../../data/services/friction_tracking_service.dart';
import '../controllers/lsa_profile_verification_controller.dart';


class LSAProfileVerificationBinding extends Bindings {
  final bool useMockBackend;

  LSAProfileVerificationBinding({this.useMockBackend = true});

  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);

    Get.lazyPut<LSAProfileRepository>(
      () => useMockBackend
          ? LSAProfileRepositoryMock()
          : LSAProfileRepositoryImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<FrictionTrackingService>(
      () => FrictionTrackingService(),
      fenix: true,
    );

    Get.lazyPut<LSAProfileVerificationController>(
      () => LSAProfileVerificationController(
        repository: Get.find<LSAProfileRepository>(),
        frictionService: Get.find<FrictionTrackingService>(),
      ),
    );
  }
}

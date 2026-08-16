import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/lsa_profile_model.dart';
import '../../../data/models/submission_result.dart';
import '../../../data/repositories/lsa_profile_repository.dart';
import '../../../data/services/friction_tracking_service.dart';

enum ViewStatus { idle, submitting, success, quarantined, serverError }

class LSAProfileVerificationController extends GetxController {
  final LSAProfileRepository _repository;
  final FrictionTrackingService _frictionService;

  LSAProfileVerificationController({
    required LSAProfileRepository repository,
    required FrictionTrackingService frictionService,
  })  : _repository = repository,
        _frictionService = frictionService;

  // ---- Form controllers (disposed in onClose) ----
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController certificationController =
      TextEditingController();
  final TextEditingController yearsController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController predecessorIdController =
      TextEditingController();

  final FocusNode fullNameFocusNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ---- Reactive state ----
  final Rx<ViewStatus> status = ViewStatus.idle.obs;
  final RxString statusMessage = ''.obs;
  final RxInt frictionEventCount = 0.obs;
  final RxnString lastTraceId = RxnString();

  bool get isSubmitting => status.value == ViewStatus.submitting;

  @override
  void onInit() {
    super.onInit();
    _frictionService.onFrictionEvent = _onFrictionEvent;
    fullNameFocusNode.addListener(_handleFullNameFocusChange);
  }

  void _handleFullNameFocusChange() {
    if (fullNameFocusNode.hasFocus) {
      _frictionService.startTracking();
    } else {
      _frictionService.stopTracking();
    }
  }

  void onPrimaryFieldInteraction(String _) {
    _frictionService.registerInteraction();
  }

  void _onFrictionEvent(int total) {
    frictionEventCount.value = total;
  }

  LSAProfileModel _collectFormModel() {
    return LSAProfileModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      certificationNumber: certificationController.text.trim(),
      yearsOfExperience: int.tryParse(yearsController.text.trim()),
      bio: bioController.text.trim(),
      predecessorId: predecessorIdController.text.trim().isEmpty
          ? null
          : predecessorIdController.text.trim(),
    );
  }

  Future<void> submit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    status.value = ViewStatus.submitting;
    statusMessage.value = '';

    final LSAProfileModel profile = _collectFormModel();

    try {
      final SubmissionResult result = await _repository.submitProfile(profile);
      switch (result.outcome) {
        case SubmissionOutcome.success:
          status.value = ViewStatus.success;
          lastTraceId.value = result.traceId;
          break;
        case SubmissionOutcome.serverError:
          status.value = ViewStatus.serverError;
          break;
        case SubmissionOutcome.quarantined:
          status.value = ViewStatus.quarantined;
          break;
      }
      statusMessage.value = result.message;
    } on QuarantinedException catch (error) {
      // Fail-closed halt raised before any network call was made.
      status.value = ViewStatus.quarantined;
      statusMessage.value = error.message;
    } on NetworkUnavailableException catch (error) {
      status.value = ViewStatus.serverError;
      statusMessage.value = error.message;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected submit failure', error: error, stackTrace: stackTrace);
      status.value = ViewStatus.serverError;
      statusMessage.value = 'An unexpected error occurred.';
    }
  }

  @override
  void onClose() {
    fullNameFocusNode.removeListener(_handleFullNameFocusChange);
    fullNameFocusNode.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    certificationController.dispose();
    yearsController.dispose();
    bioController.dispose();
    predecessorIdController.dispose();
    _frictionService.dispose();
    super.onClose();
  }
}

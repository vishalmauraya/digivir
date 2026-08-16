import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../core/security/fail_closed_validator.dart';
import '../../core/security/validation_result.dart';
import '../../core/utils/app_logger.dart';
import '../models/lsa_profile_model.dart';
import '../models/submission_result.dart';
import 'lsa_profile_repository.dart';

class LSAProfileRepositoryImpl implements LSAProfileRepository {
  final ApiClient _apiClient;

  LSAProfileRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<SubmissionResult> submitProfile(LSAProfileModel profile) async {
    final ValidationResult validation = FailClosedValidator.validate(profile);

    if (!validation.isValid) {
      throw QuarantinedException(
        validation.quarantineReason ?? 'Fail-closed halt.',
      );
    }

    try {
      final Map<String, dynamic> response = await _apiClient.post(
        path: ApiConstants.lsaProfileVerificationEndpoint,
        payload: profile.toJson(),
      );

      return SubmissionResult(
        outcome: SubmissionOutcome.success,
        message: 'Profile submitted and verified successfully.',
        traceId: response['trace_id'] as String?,
      );
    } on ServerException catch (error) {
      AppLogger.error('Server rejected submission', error: error);
      return SubmissionResult(
        outcome: SubmissionOutcome.serverError,
        message: error.message,
      );
    }
  }
}

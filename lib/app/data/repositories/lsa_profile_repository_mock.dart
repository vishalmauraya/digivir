import '../../core/network/api_exception.dart';
import '../../core/security/fail_closed_validator.dart';
import '../../core/security/metadata_header_generator.dart';
import '../../core/security/validation_result.dart';
import '../models/lsa_profile_model.dart';
import '../models/submission_result.dart';
import 'lsa_profile_repository.dart';


class LSAProfileRepositoryMock implements LSAProfileRepository {
  static const String simulateServerErrorSentinel = 'SIMULATE_SERVER_ERROR';

  @override
  Future<SubmissionResult> submitProfile(LSAProfileModel profile) async {
    // Simulated network latency so loading states are visible on-screen.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final ValidationResult validation = FailClosedValidator.validate(profile);
    if (!validation.isValid) {
      throw QuarantinedException(
        validation.quarantineReason ?? 'Fail-closed halt.',
      );
    }

    if (profile.predecessorId == simulateServerErrorSentinel) {
      return const SubmissionResult(
        outcome: SubmissionOutcome.serverError,
        message: 'Server rejected the request (simulated 422 response).',
      );
    }

    final RequestMetadata metadata =
        MetadataHeaderGenerator.generate(profile.toJson());

    return SubmissionResult(
      outcome: SubmissionOutcome.success,
      message: 'Profile submitted and verified successfully.',
      traceId: metadata.traceId,
    );
  }
}
